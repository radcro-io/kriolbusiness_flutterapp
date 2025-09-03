// lib/features/auth/presentation/widgets/account_type_selector.dart

import 'package:flutter/material.dart';

/// Enum para tipos de conta
enum AccountType {
  cliente('Cliente', Icons.person_outline, Icons.person, 
         'Conta pessoal', 'Para clientes individuais', Color(0xFF4CAF50)),
  empresa('Empresa', Icons.business_outlined, Icons.business,
         'Conta comercial', 'Para empresas e negócios', Color(0xFF2196F3));

  const AccountType(
    this.label, 
    this.outlinedIcon, 
    this.filledIcon, 
    this.title, 
    this.description, 
    this.color
  );
  
  final String label;
  final IconData outlinedIcon;
  final IconData filledIcon;
  final String title;
  final String description;
  final Color color;
}

/// Widget para seleção de tipo de conta com design moderno
class AccountTypeSelector extends StatefulWidget {
  final AccountType selectedType;
  final ValueChanged<AccountType> onTypeChanged;
  final bool enabled;

  const AccountTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    this.enabled = true,
  });

  @override
  State<AccountTypeSelector> createState() => _AccountTypeSelectorState();
}

class _AccountTypeSelectorState extends State<AccountTypeSelector>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _onTypeSelected(AccountType type) {
    if (!widget.enabled) return;
    
    widget.onTypeChanged(type);
    
    // Animação de feedback
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    
    // Pequeno pulse para feedback visual
    _pulseController.forward().then((_) {
      _pulseController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título da seção
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            'Escolha o tipo de conta',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: const Color(0xFF1B365D),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Cards de seleção
        Row(
          children: AccountType.values.map((type) {
            final isSelected = widget.selectedType == type;
            
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: type == AccountType.cliente ? 8 : 0,
                  left: type == AccountType.empresa ? 8 : 0,
                ),
                child: _buildAccountTypeCard(type, isSelected),
              ),
            );
          }).toList(),
        ),
        
        // Descrição do tipo selecionado
        const SizedBox(height: 16),
        _buildSelectedTypeDescription(),
      ],
    );
  }

  Widget _buildAccountTypeCard(AccountType type, bool isSelected) {
    return AnimatedBuilder(
      animation: Listenable.merge([_scaleAnimation, _pulseAnimation]),
      builder: (context, child) {
        final scale = isSelected && _animationController.isAnimating
            ? _scaleAnimation.value
            : isSelected && _pulseController.isAnimating
                ? _pulseAnimation.value
                : 1.0;
                
        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTap: () => _onTypeSelected(type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isSelected 
                    ? type.color.withOpacity(0.1)
                    : Colors.white,
                border: Border.all(
                  color: isSelected 
                      ? type.color
                      : Colors.grey.shade300,
                  width: isSelected ? 2.5 : 1.5,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isSelected 
                        ? type.color.withOpacity(0.2)
                        : Colors.grey.withOpacity(0.1),
                    blurRadius: isSelected ? 12 : 6,
                    offset: const Offset(0, 4),
                    spreadRadius: isSelected ? 2 : 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ícone com animação
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      key: ValueKey('${type.label}_$isSelected'),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? type.color.withOpacity(0.15)
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSelected ? type.filledIcon : type.outlinedIcon,
                        size: 32,
                        color: isSelected 
                            ? type.color
                            : Colors.grey.shade600,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Título
                  Text(
                    type.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected 
                          ? type.color
                          : Colors.grey.shade800,
                    ),
                  ),
                  
                  const SizedBox(height: 4),
                  
                  // Descrição
                  Text(
                    type.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected 
                          ? type.color.withOpacity(0.8)
                          : Colors.grey.shade600,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Indicador de seleção
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isSelected ? 24 : 0,
                    height: 3,
                    decoration: BoxDecoration(
                      color: type.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectedTypeDescription() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Container(
        key: ValueKey(widget.selectedType),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.selectedType.color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: widget.selectedType.color.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: widget.selectedType.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                widget.selectedType.filledIcon,
                size: 20,
                color: widget.selectedType.color,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Conta ${widget.selectedType.label}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: widget.selectedType.color,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getDetailedDescription(widget.selectedType),
                    style: TextStyle(
                      color: widget.selectedType.color.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDetailedDescription(AccountType type) {
    switch (type) {
      case AccountType.cliente:
        return 'Perfeita para uso pessoal. Você poderá adicionar informações como telefone, país e data de nascimento no seu perfil.';
      case AccountType.empresa:
        return 'Ideal para negócios. Você poderá adicionar endereço, localização, categoria e informações comerciais no seu perfil.';
    }
  }
}

