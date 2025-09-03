// lib/features/auth/presentation/pages/auth_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kriolbusiness/features/auth/presentation/bloc/presentation_auth_bloc.dart';
import 'package:kriolbusiness/features/auth/presentation/bloc/presentation_auth_event.dart';
import 'package:kriolbusiness/features/auth/presentation/bloc/presentation_auth_state.dart';
import 'package:kriolbusiness/features/auth/presentation/widgets/account_type_selector.dart';

/// Página de autenticação moderna com seleção de tipo de conta
class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  
  bool _isLoginMode = true;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  AccountType _selectedAccountType = AccountType.cliente;
  bool _isUsernameAvailable = true;
  bool _isCheckingUsername = false;

  late AnimationController _pageAnimationController;
  late AnimationController _formAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _pageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _formAnimationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _formAnimationController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _pageAnimationController,
      curve: Curves.elasticOut,
    ));

    // Iniciar animação da página
    _pageAnimationController.forward();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _usernameController.dispose();
    _pageAnimationController.dispose();
    _formAnimationController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
    });
    
    _formKey.currentState?.reset();
    _clearControllers();
    
    if (!_isLoginMode) {
      _formAnimationController.forward();
    } else {
      _formAnimationController.reverse();
    }
  }

  void _clearControllers() {
    _nameController.clear();
    _usernameController.clear();
    _confirmPasswordController.clear();
  }

  void _checkUsernameAvailability(String username) {
    if (username.isEmpty) {
      setState(() {
        _isUsernameAvailable = true;
        _isCheckingUsername = false;
      });
      return;
    }

    else if(username.isNotEmpty && username.length <= 3) {
      setState(() {
        _isUsernameAvailable = false;
        _isCheckingUsername = false;
      });
      return;
    }
    else if (username.length >= 4) {
      setState(() {
        _isCheckingUsername = true;
      });
      
      context.read<AuthBloc>().add(CheckUsernameAvailability(username: username,
        isAvailable: _isUsernameAvailable,
      ));
    }
  }

  void _submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_isLoginMode && !_isUsernameAvailable) {
      _showSnackBar(
        'Nome de usuário não está disponível',
        isError: true,
      );
      return;
    }

    final authBloc = context.read<AuthBloc>();

    if (_isLoginMode) {
      authBloc.add(LoginRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ));
    } else {
      // Registro com tipo de conta
      if (_selectedAccountType == AccountType.cliente) {
        authBloc.add(RegisterRequested(
          nome: _nameController.text.trim(),
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ));
      } else {
        authBloc.add(RegisterEmpresaRequested(
          nome: _nameController.text.trim(),
          username: _usernameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ));
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Logo/Ícone
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF1B365D),
                const Color(0xFF1B365D).withOpacity(0.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1B365D).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(
            Icons.business_center,
            size: 40,
            color: Colors.white,
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Título
        Text(
          'KriolBusiness',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: const Color(0xFF1B365D),
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Subtítulo
        Text(
          _isLoginMode 
              ? 'Bem-vindo de volta!' 
              : 'Crie sua conta e comece agora',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      onChanged: _checkUsernameAvailability,
      decoration: InputDecoration(
        labelText: 'Nome de Usuário',
        hintText: 'Ex: joao_silva',
        prefixIcon: const Icon(Icons.alternate_email),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        helperText: 'Apenas letras, números e underscore',
        suffixIcon: _buildUsernameValidationIcon(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nome de usuário é obrigatório';
        }
        if (value.length < 3) {
          return 'Mínimo 3 caracteres';
        }
        if (!RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(value)) {
          return 'Formato inválido';
        }
        if (!_isUsernameAvailable) {
          return 'Nome não disponível';
        }
        return null;
      },
    );
  }

  Widget? _buildUsernameValidationIcon() {
    if (_usernameController.text.isEmpty) {
      return null;
    }

     if (_usernameController.text.isNotEmpty && _usernameController.text.length < 3) {
      return Icon(
        _isUsernameAvailable ? Icons.check_circle : Icons.error,
        color:Colors.red,
      );
    }

    if (_isCheckingUsername) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    
    if (_usernameController.text.length >= 3) {
      return Icon(
        _isUsernameAvailable ? Icons.check_circle : Icons.error,
        color: _isUsernameAvailable ? Colors.green : Colors.red,
      );
    }

    return null;
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    String? hint,
    IconData? prefixIcon,
    bool obscureText = false,
    bool? passwordVisible,
    VoidCallback? togglePasswordVisibility,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText && !(passwordVisible ?? false),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
        suffixIcon: togglePasswordVisibility != null
            ? IconButton(
                icon: Icon(
                  (passwordVisible ?? false)
                      ? Icons.visibility_off
                      : Icons.visibility,
                ),
                onPressed: togglePasswordVisibility,
              )
            : null,
      ),
      validator: validator,
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        
        return Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFB91C1C),
                const Color(0xFFB91C1C).withOpacity(0.8),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFB91C1C).withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    _getSubmitButtonText(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        );
      },
    );
  }

  String _getSubmitButtonText() {
    if (_isLoginMode) {
      return 'ENTRAR';
    } else {
      return 'CRIAR CONTA ${_selectedAccountType.label.toUpperCase()}';
    }
  }

  Widget _buildToggleModeButton() {
    return TextButton(
      onPressed: _toggleMode,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.grey),
          children: [
            TextSpan(
              text: _isLoginMode
                  ? 'Não tem uma conta? '
                  : 'Já tem uma conta? ',
            ),
            TextSpan(
              text: _isLoginMode ? 'Registre-se' : 'Faça Login',
              style: const TextStyle(
                color: Color(0xFF1B365D),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    if (_isLoginMode) return const SizedBox.shrink();
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _selectedAccountType.color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedAccountType.color.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.info_outline,
              color: _selectedAccountType.color,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _selectedAccountType == AccountType.empresa
                    ? 'Você poderá adicionar informações comerciais como endereço, categoria e localização no seu perfil.'
                    : 'Você poderá completar seu perfil com telefone, país e outras informações pessoais.',
                style: TextStyle(
                  color: _selectedAccountType.color.withOpacity(0.8),
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            _showSnackBar(state.message, isError: true);
          } else if (state is AuthAuthenticated) {
            _showSnackBar('Conta de cliente criada com sucesso!');
          } else if (state is EmpresaAuthenticated) {
            _showSnackBar('Conta de empresa criada com sucesso!');
          } else if (state is UsernameAvailable) {
            setState(() {
              _isUsernameAvailable = state.isAvailable;
              _isCheckingUsername = false;
            });
          }
        },
        child: SafeArea(
          child: SlideTransition(
            position: _slideAnimation,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        _buildHeader(),
                        const SizedBox(height: 40),

                        // Formulário
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // Seletor de tipo de conta (apenas no registro)
                              if (!_isLoginMode) ...[
                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: AccountTypeSelector(
                                    selectedType: _selectedAccountType,
                                    onTypeChanged: (type) {
                                      setState(() {
                                        _selectedAccountType = type;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 32),
                              ],

                              // Campos de registro
                              if (!_isLoginMode) ...[
                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: _buildFormField(
                                    controller: _nameController,
                                    label: _selectedAccountType == AccountType.empresa 
                                        ? 'Nome da Empresa' 
                                        : 'Nome Completo',
                                    hint: _selectedAccountType == AccountType.empresa
                                        ? 'Ex: Minha Empresa Ltda'
                                        : 'Ex: João Silva',
                                    prefixIcon: _selectedAccountType.filledIcon,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Nome é obrigatório';
                                      }
                                      if (value.length < 2) {
                                        return 'Mínimo 2 caracteres';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20),

                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: _buildUsernameField(),
                                ),
                                const SizedBox(height: 20),
                              ],

                              // Campo Email
                              _buildFormField(
                                controller: _emailController,
                                label: 'Email',
                                hint: 'seu@email.com',
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email é obrigatório';
                                  }
                                  if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                                      .hasMatch(value)) {
                                    return 'Email inválido';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Campo Senha
                              _buildFormField(
                                controller: _passwordController,
                                label: 'Senha',
                                hint: 'Mínimo 6 caracteres',
                                prefixIcon: Icons.lock_outline,
                                obscureText: true,
                                passwordVisible: _isPasswordVisible,
                                togglePasswordVisibility: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Senha é obrigatória';
                                  }
                                  if (value.length < 6) {
                                    return 'Mínimo 6 caracteres';
                                  }
                                  return null;
                                },
                              ),

                              // Campo Confirmar Senha (apenas no registro)
                              if (!_isLoginMode) ...[
                                const SizedBox(height: 20),
                                FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: _buildFormField(
                                    controller: _confirmPasswordController,
                                    label: 'Confirme a Senha',
                                    hint: 'Digite a senha novamente',
                                    prefixIcon: Icons.lock_outline,
                                    obscureText: true,
                                    passwordVisible: _isConfirmPasswordVisible,
                                    togglePasswordVisibility: () {
                                      setState(() {
                                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                      });
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Confirmação obrigatória';
                                      }
                                      if (value != _passwordController.text) {
                                        return 'Senhas não coincidem';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                              
                              const SizedBox(height: 32),

                              // Botão Principal
                              _buildSubmitButton(),
                              const SizedBox(height: 20),

                              // Botão para alternar modo
                              _buildToggleModeButton(),

                              // Card informativo
                              const SizedBox(height: 20),
                              _buildInfoCard(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

