import 'package:bottom_sheet_image_picker/bottom_sheet_image_picker.dart';
import 'package:bottom_sheet_image_picker/src/media_controller.dart';
import 'package:bottom_sheet_image_picker/src/widgets/media_tile.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaList extends StatefulWidget {
  const MediaList({
    required this.album,
    required this.mediaController,
    required this.previousList,
    this.mediaCount,
    this.decoration,
    this.scrollController,
  });

  final AssetPathEntity album;
  final MediaController mediaController;
  final List<Media> previousList;
  final MediaCount? mediaCount;
  final PickerDecoration? decoration;
  final ScrollController? scrollController;

  @override
  _MediaListState createState() => _MediaListState();
}

class _MediaListState extends State<MediaList> {
  final List<Widget> _mediaList = [];
  int currentPage = 0;
  int? lastPage;
  AssetPathEntity? album;
  List<Media> selectedMedias = [];

  @override
  void initState() {
    album = widget.album;
    if (widget.mediaCount == MediaCount.multiple) {
      selectedMedias.addAll(widget.previousList);
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          widget.mediaController.onUpdateSelection!(selectedMedias);
        },
      );
    }
    _fetchNewMedia();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _resetAlbum();
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        _handleScrollEvent(scroll);
        return true;
      },
      child: Scrollbar(
        child: GridView.builder(
          controller: widget.scrollController,
          itemCount: _mediaList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.decoration!.columnCount,
          ),
          itemBuilder: (BuildContext context, int index) {
            return _mediaList[index];
          },
        ),
      ),
    );
  }

  void _resetAlbum() {
    if (album != null) {
      if (album!.id != widget.album.id) {
        _mediaList.clear();
        album = widget.album;
        currentPage = 0;
        _fetchNewMedia();
      }
    }
  }

  void _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  Future<void> _fetchNewMedia() async {
    lastPage = currentPage;
    final PermissionState result = await PhotoManager.requestPermissionExtend();
    if (result == PermissionState.authorized ||
        result == PermissionState.limited) {
      final List<AssetEntity> assets = await album!.getAssetListPaged(
        page: currentPage,
        size: 60,
      );
      final List<Widget> temp = assets
          .map(
            (asset) => MediaTile(
              media: asset,
              onSelected: (bool isSelected, Media selectedMedia) {
                if (isSelected) {
                  selectedMedias.add(selectedMedia);
                } else {
                  selectedMedias.removeWhere(
                    (media) => media.id == selectedMedia.id,
                  );
                }
                setState(() {});
                widget.mediaController.onUpdateSelection!(selectedMedias);
              },
              isSelected: isPreviouslySelected(asset),
              decoration: widget.decoration,
            ),
          )
          .toList();

      setState(() {
        _mediaList.addAll(temp);
        currentPage++;
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  bool isPreviouslySelected(AssetEntity media) {
    return selectedMedias.any((element) => element.id == media.id);
  }
}
