import { NavigationContainer } from '@react-navigation/native';
import { createNativeStackNavigator } from '@react-navigation/native-stack';
import Login from './Interfaces/Login';
import AdminHome from './Interfaces/AdminHome'; // Suponiendo que tienes estos componentes
import AlumnoHome from './Interfaces/AlumnoHome';
import ProfesorHome from './Interfaces/ProfesorHome';

const Stack = createNativeStackNavigator();

export default function App() {
    return (
        <NavigationContainer>
            <Stack.Navigator initialRouteName="Login">
                <Stack.Screen name="Login" component={Login} options={{ title: 'Iniciar sesión' }} />

                {/* Comentando estas pantallas temporalmente
        <Stack.Screen name="AdminHome" component={AdminHome} />
        <Stack.Screen name="AlumnoHome" component={AlumnoHome} />
        <Stack.Screen name="ProfesorHome" component={ProfesorHome} />
        */}

            </Stack.Navigator>
        </NavigationContainer>
    );
}
