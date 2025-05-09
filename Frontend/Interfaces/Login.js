import { useState, useEffect } from 'react';
import {
    TextInput,
    TouchableOpacity,
    Alert,
    View,
    Text,
    Image,
    StyleSheet,
    ActivityIndicator,
    Animated,
    Dimensions,
    KeyboardAvoidingView,
    Platform,
    ScrollView
} from 'react-native';
import axios from 'axios';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { Ionicons } from '@expo/vector-icons';
import { LinearGradient } from 'expo-linear-gradient';

const { width } = Dimensions.get('window');

const Login = ({ navigation }) => {
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [loading, setLoading] = useState(false);
    const logoAnim = new Animated.Value(0);
    const formAnim = new Animated.Value(0);

    useEffect(() => {
        Animated.timing(logoAnim, {
            toValue: 1,
            duration: 1000,
            useNativeDriver: true,
        }).start();

        Animated.timing(formAnim, {
            toValue: 1,
            duration: 1500,
            useNativeDriver: true,
        }).start();
    }, []);

    const handleSignIn = async () => {
        if (!email || !password) {
            Alert.alert('Error', 'Por favor, completa todos los campos');
            return;
        }

        setLoading(true);

        try {
            const response = await axios.post('http://192.168.0.101:5000/rol/signin', {
                email,
                password,
            });

            if (response.status === 200) {
                const { role, nombre } = response.data.rol;
                await AsyncStorage.setItem('userName', nombre);
                await AsyncStorage.setItem('userEmail', email);

                if (role === 'admin') navigation.replace('AdminHome');
                else if (role === 'alumno') navigation.replace('AlumnoHome');
                else if (role === 'profesor') navigation.replace('ProfesorHome');
            }
        } catch (error) {
            Alert.alert('Error', 'Usuario o contraseña incorrectos');
        } finally {
            setLoading(false);
        }
    };

    // ...los imports y hooks se mantienen igual...

    return (
        <View style={styles.container}>
            <KeyboardAvoidingView
                style={{ flex: 1 }}
                behavior={Platform.OS === 'ios' ? 'padding' : undefined}
            >
                <ScrollView
                    contentContainerStyle={styles.scrollContainer}
                    keyboardShouldPersistTaps="handled"
                >
                    <Animated.View style={[styles.logoContainer, { opacity: logoAnim }]}>
                        <Image
                            source={require('../../assets/logo.png')}
                            style={styles.logo}
                        />
                    </Animated.View>

                    <Animated.View style={[styles.formContainer, { opacity: formAnim }]}>
                        <Ionicons name="person-circle-outline" size={90} color="#3f51b5" style={styles.profileIcon} />
                        <Text style={styles.title}>Bienvenido</Text>

                        <TextInput
                            style={styles.input}
                            value={email}
                            onChangeText={setEmail}
                            placeholder="Correo electrónico"
                            keyboardType="email-address"
                            placeholderTextColor="#999"
                        />
                        <TextInput
                            style={styles.input}
                            value={password}
                            onChangeText={setPassword}
                            placeholder="Contraseña"
                            secureTextEntry
                            placeholderTextColor="#999"
                        />

                        <TouchableOpacity style={styles.button} onPress={handleSignIn} disabled={loading}>
                            <LinearGradient
                                colors={['#2196F3', '#1E88E5']}
                                style={styles.gradientButton}
                            >
                                {loading
                                    ? <ActivityIndicator color="#fff" />
                                    : <Text style={styles.buttonText}>Iniciar sesión</Text>}
                            </LinearGradient>
                        </TouchableOpacity>
                    </Animated.View>
                </ScrollView>
            </KeyboardAvoidingView>
        </View>
    );

};

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: 'rgba(80,167,239,0.18)',
    },
    scrollContainer: {
        flexGrow: 1,
        justifyContent: 'center',
        alignItems: 'center',
        padding: 20,
        minHeight: Dimensions.get('window').height,
    },
    logoContainer: {
        position: 'absolute',
        top: 10,
        alignItems: 'center',
        width: '100%',
        zIndex: 2,
    },
    logo: {
        width: 400,
        height: 200,
        resizeMode: 'contain',
    },
    formContainer: {
        marginTop: 10,
        backgroundColor: '#fff',
        padding: 24,
        borderRadius: 20,
        width: '100%',
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 6 },
        shadowOpacity: 0.1,
        shadowRadius: 10,
        elevation: 6,
        zIndex: 1,
    },
    profileIcon: {
        alignSelf: 'center',
        marginBottom: 10,
    },
    title: {
        fontSize: 22,
        fontWeight: 'bold',
        color: '#333',
        textAlign: 'center',
        marginBottom: 20,
    },
    input: {
        backgroundColor: '#f5f5f5',
        paddingVertical: 12,
        paddingHorizontal: 16,
        borderRadius: 10,
        fontSize: 16,
        color: '#333',
        marginBottom: 16,
    },
    button: {
        marginTop: 10,
        borderRadius: 10,
        overflow: 'hidden',
    },
    gradientButton: {
        paddingVertical: 14,
        alignItems: 'center',
        justifyContent: 'center',
    },
    buttonText: {
        color: '#FFF',
        fontSize: 16,
        fontWeight: 'bold',
        textTransform: 'uppercase',
    },
});

export default Login;
