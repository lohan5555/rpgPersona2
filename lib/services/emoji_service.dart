import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

class EmojiService{

  void showEmojiPicker(BuildContext context, Function(String) onEmojiSelected) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Expanded(
                  child: EmojiPicker(
                    onEmojiSelected: (category, emoji) {
                      onEmojiSelected(emoji.emoji);
                      Navigator.pop(context);
                    },
                    config: const Config(
                      height: 256,
                      checkPlatformCompatibility: true,
                      categoryViewConfig: CategoryViewConfig(
                          backgroundColor: Color.fromRGBO(250, 240, 227, 0),
                          indicatorColor: Colors.black,
                          iconColor: Colors.grey,
                          iconColorSelected: Colors.black
                      ),
                      emojiViewConfig: EmojiViewConfig(
                        backgroundColor: Color.fromRGBO(250, 240, 227, 0),
                        columns: 7,
                        emojiSizeMax: 28,
                      ),
                      bottomActionBarConfig: BottomActionBarConfig(
                        showBackspaceButton: false,
                        showSearchViewButton: false,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        );
      },
    );
  }
}