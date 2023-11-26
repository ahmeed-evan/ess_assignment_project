import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:ess_assignment_project/utils.dart';
import 'package:ess_assignment_project/view/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FeedBAckScreen extends StatefulWidget {
  const FeedBAckScreen({super.key});

  @override
  State<FeedBAckScreen> createState() => _FeedBAckScreenState();
}

class _FeedBAckScreenState extends State<FeedBAckScreen> {
  final feedbackTextInputController = TextEditingController();

  File? imageTempFile;

  String? audioFile;

  late FlutterSoundRecorder recordAudio = FlutterSoundRecorder();
  late FlutterSoundPlayer audioPlayer = FlutterSoundPlayer();
  bool isRecording = false;

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      setState(() {
        imageTempFile = File(image.path);
      });
    } on PlatformException catch (e) {
      log(e.toString());
    }
  }

  _playsAudioFile() async {
    print("Play");
    await audioPlayer.startPlayer(fromURI: audioFile);
  }

  _stopAudioFile() async {
    print("stop");
    await audioPlayer.stopPlayer();
  }

  togglePlay() async {
    if (audioPlayer.isStopped) {
      await _playsAudioFile();
    } else {
      await _stopAudioFile();
    }
  }

  startRecord() async {
    await recordAudio.startRecorder(toFile: 'audio');
  }

  stopRecord() async {
    final audioPath = await recordAudio.stopRecorder();
    audioFile = audioPath;
  }

  @override
  void initState() {
    initRecoder();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  _body() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            _feedbackInputTextFiled(),
            customSpacerHeight(height: 20),
            _uploadPhoto(),
            customSpacerHeight(height: 20),
            _recordAudioLayout(),
            const Spacer(),
            customButton(buttonText: "Submit", onClickAction: () {
              Fluttertoast.showToast(msg: "Uploaded to server");
            })
          ],
        ),
      ),
    );
  }

  _feedbackInputTextFiled() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey, width: 1)),
      child: TextField(
          textInputAction: TextInputAction.done,
          controller: feedbackTextInputController,
          maxLines: 4,
          decoration: InputDecoration.collapsed(
              hintText: "Write Something..", hintStyle: hintTextStyle)),
    );
  }

  _uploadPhoto() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey, width: 1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _imageFile(),
          _imagePickerButton(),
        ],
      ),
    );
  }

  _imageFile() {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1, color: Colors.grey)),
        height: 100,
        width: 100,
        child: imageTempFile != null
            ? Image.file(
                imageTempFile!,
                fit: BoxFit.fill,
              )
            : const FlutterLogo());
  }

  _imagePickerButton() {
    return TextButton.icon(
      style: TextButton.styleFrom(foregroundColor: Colors.transparent),
      onPressed: () => pickImage(),
      icon: const Icon(
        Icons.image,
        color: Colors.grey,
      ),
      label: Text("Upload Image", style: defaultTextStyle),
    );
  }

  _recordAudioLayout() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey, width: 1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _recordImage(),
          ),
          _playButton(),
          _recordButton(),
        ],
      ),
    );
  }

  _recordImage() {
    return Image.asset(
      "assets/audio_image.png",
      height: 30,
      fit: BoxFit.fill,
    );
  }

  _playButton() {
    return IconButton(
      icon: const Icon(Icons.play_arrow),
      onPressed: audioFile == null ? null : () => togglePlay(),
    );
  }

  _recordButton() {
    return IconButton(
      icon: Icon(
        Icons.mic,
        color: recordAudio.isRecording ? Colors.red : Colors.grey,
      ),
      onPressed: () async {
        if (recordAudio.isRecording) {
          await stopRecord();
        } else {
          await startRecord();
        }
        setState(() {});
      },
    );
  }

  void initRecoder() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      await recordAudio.openRecorder();
      audioPlayer.openPlayer();
    }
  }
}
