import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum DownloadStatus {notDownloaded, fetchingDownload, downloading, downloaded}

class DownloadScreen extends StatelessWidget{
  const DownloadScreen({
    super.key, 
    required this.status, 
    this.transitionDuration=const Duration(milliseconds: 500),
    required this.onDownload,
    required this.onCancel,
    required this.onOpen,
    this.downloadProgress=0
  });

  final DownloadStatus status;
  final Duration transitionDuration;
  final double downloadProgress;
  final VoidCallback onDownload;
  final VoidCallback onCancel;
  final VoidCallback onOpen;

  bool get _isDownloading => status == DownloadStatus.downloading;
  bool get _isFetching => status == DownloadStatus.fetchingDownload;
  bool get _isDownloaded => status == DownloadStatus.downloaded;

  void _onPressed() {
    switch (status) {
      case DownloadStatus.notDownloaded:
        onDownload();
      case DownloadStatus.fetchingDownload:
        break;
      case DownloadStatus.downloading:
        onCancel();
      case DownloadStatus.downloaded:
        onOpen();
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onPressed,
      child: Stack(
        children: [
          ButtonShapeWidget(
            isDownloading: _isDownloading, 
            isDownloaded: _isDownloaded, 
            isFetching: _isFetching, 
            transitionDuration: transitionDuration
          ),
          Positioned.fill(
            child: AnimatedOpacity(
              opacity: _isDownloading || _isFetching ? 1 : 0, 
              duration: transitionDuration,
              curve: Curves.ease,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ProgressIndicatorWidget(
                    downloadProgress: downloadProgress,
                    isDownloading: _isDownloading,
                    isFetching: _isFetching,
                  ),
                  if(_isDownloading)
                    const Icon(
                      Icons.stop,
                      size: 14,
                      color: CupertinoColors.activeBlue,
                    )
                ],
              )
              
            )
          )
        ],
      ),
    );
    
  }

}

class ButtonShapeWidget extends StatelessWidget {
  const ButtonShapeWidget({
    super.key,
    required this.isDownloading,
    required this.isDownloaded,
    required this.isFetching,
    required this.transitionDuration
  });

  final bool isDownloading;
  final bool isDownloaded;
  final bool isFetching;
  final Duration transitionDuration;
  
  @override
  Widget build(BuildContext context) {
    final ShapeDecoration shape;
    if(isDownloading || isFetching) {
      shape=const ShapeDecoration(shape: CircleBorder(), color: Colors.transparent);
    }else {
      shape= const ShapeDecoration(shape: StadiumBorder(), color: CupertinoColors.lightBackgroundGray);
    }

    return AnimatedContainer(
      duration: transitionDuration,
      curve: Curves.ease, 
      width: double.infinity,
      decoration: shape,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: AnimatedOpacity(
          opacity: isDownloading || isFetching ? 0 : 1, 
          duration: transitionDuration,
          curve: Curves.ease,
          child: Text(
            isDownloaded ? 'OPEN' : 'GET',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: CupertinoColors.activeBlue
            ),
          ),
        ),
      )
    );
  }
}


@immutable
class  ProgressIndicatorWidget extends StatelessWidget {
  const ProgressIndicatorWidget({
    super.key,
    required this.downloadProgress,
    required this.isDownloading,
    required this.isFetching
  });

  final double downloadProgress;
  final bool isDownloading;
  final bool isFetching;
  
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: downloadProgress), 
        duration: const Duration(milliseconds: 200), 
        builder: (context, progress, child) {
          return CircularProgressIndicator(
            backgroundColor: isDownloading
              ? CupertinoColors.lightBackgroundGray
              : Colors.transparent,
            valueColor: AlwaysStoppedAnimation(
              isFetching
                ? CupertinoColors.lightBackgroundGray
                : CupertinoColors.activeBlue,
            ),
            strokeWidth: 2,
            value: isFetching ? null : progress,
          );
        }
      ),
    );
  }

  
}