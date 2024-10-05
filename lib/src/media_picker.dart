part of bottom_sheet_image_picker;

///The MediaPicker widget that will select media files form storage
class MediaPicker extends StatefulWidget {
  ///The MediaPicker constructor that will select media files form storage
  MediaPicker({
    required this.onDone,
    required this.mediaList,
    required this.onCancel,
    this.mediaCount = MediaCount.multiple,
    this.mediaType = MediaType.all,
    this.decoration,
    this.scrollController,
  });

  ///CallBack on image pick is done
  final ValueChanged<List<Media>> onDone;

  ///Previously selected list of media in your app
  final List<Media> mediaList;

  ///Callback on cancel the picking action
  final VoidCallback onCancel;

  ///make picker to select multiple or single media file
  final MediaCount mediaCount;

  ///Make picker to select specific type of media, video or image
  final MediaType mediaType;

  ///decorate the UI of picker
  final PickerDecoration? decoration;

  ///assign a scroll controller to Media GridView of Picker
  final ScrollController? scrollController;

  @override
  _MediaPickerState createState() => _MediaPickerState();
}

class _MediaPickerState extends State<MediaPicker> {
  PickerDecoration? _decoration;
  AssetPathEntity? _selectedAlbum;
  List<AssetPathEntity>? _albums;
  final MediaController mediaController = MediaController();

  @override
  void initState() {
    _initAlbums();
    _decoration = widget.decoration ?? PickerDecoration();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: _albums == null
          ? LoadingWidget(
              decoration: widget.decoration!,
            )
          : _albums!.isEmpty
              ? NoMedia()
              : Column(
                  children: <Widget>[
                    Header(
                      onDone: widget.onDone,
                      mediaController: mediaController,
                      selectedAlbum: _selectedAlbum!,
                      mediaCount: widget.mediaCount,
                      decoration: _decoration,
                      onSelect: (album) {
                        setState(() => _selectedAlbum = album);
                      },
                      albums: _albums!,
                    ),
                    Expanded(
                      child: MediaList(
                        album: _selectedAlbum!,
                        mediaController: mediaController,
                        previousList: widget.mediaList,
                        mediaCount: widget.mediaCount,
                        decoration: widget.decoration,
                        scrollController: widget.scrollController,
                      ),
                    ),
                  ],
                ),
    );
  }

  Future<void> _initAlbums() async {
    RequestType type = RequestType.common;
    if (widget.mediaType == MediaType.all) {
      type = RequestType.common;
    } else if (widget.mediaType == MediaType.video) {
      type = RequestType.video;
    } else if (widget.mediaType == MediaType.image) {
      type = RequestType.image;
    }

    final PermissionState result = await PhotoManager.requestPermissionExtend();
    if (result == PermissionState.authorized ||
        result == PermissionState.limited) {
      final List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(type: type);
      setState(() {
        _albums = albums;
        _selectedAlbum = _albums![0];
      });
    } else {
      PhotoManager.openSetting();
    }
  }
}
