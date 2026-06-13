import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import '../model/atendimento.dart';
import '../services/cep_service.dart';
import '../utils/input_formatters.dart';

class ConteudoFormAtendimentoDialog extends StatefulWidget {
  final Atendimento? atendimento;

  const ConteudoFormAtendimentoDialog({super.key, this.atendimento});

  @override
  State<ConteudoFormAtendimentoDialog> createState() =>
      _ConteudoFormAtendimentoDialogState();
}

class _ConteudoFormAtendimentoDialogState
    extends State<ConteudoFormAtendimentoDialog> {

  final descricaoController = TextEditingController();
  final dataController = TextEditingController();
  final horaController = TextEditingController();
  final valorController = TextEditingController();
  final localizacaoController = TextEditingController();
  final cepController = TextEditingController();
  bool _obtendoLocalizacao = false;
  bool _buscandoCep = false;
  final _cepService = CepService();

  @override
  void initState() {
    super.initState();
    if (widget.atendimento != null) {
      descricaoController.text = widget.atendimento!.descricao;
      dataController.text = widget.atendimento!.data;
      horaController.text = widget.atendimento!.hora;
      valorController.text = widget.atendimento!.valor.toString();
      localizacaoController.text = widget.atendimento!.localizacao;
    }
  }

  Future<void> _buscarCep() async {
    setState(() => _buscandoCep = true);
    try {
      final cep = await _cepService.buscarCep(cepController.text);
      setState(() {
        localizacaoController.text = cep.enderecoFormatado;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _buscandoCep = false);
    }
  }

  Future<void> _obterLocalizacao() async {
    setState(() => _obtendoLocalizacao = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          final abrir = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('GPS desativado'),
              content: const Text(
                'A localização do dispositivo está desativada. Deseja abrir as configurações para ativá-la?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Ativar'),
                ),
              ],
            ),
          );
          if (abrir == true) await Geolocator.openLocationSettings();
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Permissão de localização negada.')),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          final abrir = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Permissão negada'),
              content: const Text(
                'A permissão de localização foi negada permanentemente. Deseja abrir as configurações do aplicativo para habilitá-la?',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Abrir configurações'),
                ),
              ],
            ),
          );
          if (abrir == true) await Geolocator.openAppSettings();
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      setState(() {
        localizacaoController.text =
            'Lat: ${position.latitude.toStringAsFixed(6)} | Long: ${position.longitude.toStringAsFixed(6)}';
      });
    } finally {
      if (mounted) setState(() => _obtendoLocalizacao = false);
    }
  }

  double _converterValor(String valorTexto) {
    final valorLimpo = valorTexto
        .replaceAll('R\$', '')
        .replaceAll('.', '')
        .replaceAll(',', '.')
        .trim();
    return double.tryParse(valorLimpo) ?? 0;
  }

  void _salvar() {
    final atendimento = Atendimento(
      id: widget.atendimento?.id,
      descricao: descricaoController.text,
      data: dataController.text,
      hora: horaController.text,
      valor: _converterValor(valorController.text),
      localizacao: localizacaoController.text,
    );
    Navigator.pop(context, atendimento);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).viewPadding.bottom +
            24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Text(
            widget.atendimento == null ? 'Novo Atendimento' : 'Editar Atendimento',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 20),

          TextFormField(
            controller: descricaoController,
            decoration: const InputDecoration(
              labelText: 'Descrição do serviço',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.description),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: dataController,
                  decoration: const InputDecoration(
                    labelText: 'Data',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                    hintText: 'dd/mm/aaaa',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [DateInputFormatter()],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  controller: horaController,
                  decoration: const InputDecoration(
                    labelText: 'Hora',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.access_time),
                    hintText: 'hh:mm',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [TimeInputFormatter()],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          TextFormField(
            controller: valorController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CurrencyTextInputFormatter.currency(
                locale: 'pt_BR',
                symbol: 'R\$ ',
                decimalDigits: 2,
              ),
            ],
            decoration: const InputDecoration(
              labelText: 'Valor',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.attach_money),
            ),
          ),

          const SizedBox(height: 12),

          TextFormField(
            controller: cepController,
            keyboardType: TextInputType.number,
            inputFormatters: [CepInputFormatter()],
            decoration: InputDecoration(
              labelText: 'CEP',
              hintText: '00000-000',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.map),
              suffixIcon: _buscandoCep
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : IconButton(
                      icon: const Icon(Icons.search),
                      tooltip: 'Buscar endereço pelo CEP',
                      onPressed: _buscarCep,
                    ),
            ),
          ),

          const SizedBox(height: 12),

          TextFormField(
            controller: localizacaoController,
            decoration: const InputDecoration(
              labelText: 'Localização',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on),
            ),
          ),

          const SizedBox(height: 8),

          OutlinedButton.icon(
            onPressed: _obtendoLocalizacao ? null : _obterLocalizacao,
            icon: _obtendoLocalizacao
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location),
            label: Text(_obtendoLocalizacao ? 'Obtendo...' : 'Obter localização'),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _salvar,
                  child: const Text('Salvar'),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}
