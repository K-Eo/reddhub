export enum FileType {
  JPEG,
  PNG,
  GIF,
  UNSUPPORTED,
}

interface FileMetada {
  type: FileType
  size: number
}

interface ImageMetadata {
  width: number
  height: number
}

export const extractImageMetadata = (file: File): Promise<ImageMetadata> => {
  return new Promise(resolve => {
    const image = new Image()
    image.crossOrigin = 'anonymous'

    image.onload = function() {
      const img = this as HTMLImageElement
      resolve({ width: img.width, height: img.height })
    }

    image.src = window.URL.createObjectURL(file)
  })
}

export const extractFileMetadata = (file: File): Promise<FileMetada> => {
  return new Promise<FileMetada>((resolve, reject) => {
    if (!file) {
      reject(new Error('Missing file'))
      return
    }

    const reader = new FileReader()

    reader.onloadend = e => {
      let header = ''
      const arr = new Uint8Array(e.target.result).subarray(0, 4)

      for (let i = 0; i < arr.length; i++) {
        header += arr[i].toString(16)
      }

      const metadata: FileMetada = {
        type: FileType.UNSUPPORTED,
        size: file.size,
      }

      switch (header) {
        case '89504e47':
          metadata.type = FileType.PNG
          break
        case 'ffd8ffe0':
        case 'ffd8ffe1':
        case 'ffd8ffe2':
        case 'ffd8ffe3':
        case 'ffd8ffe8':
          metadata.type = FileType.JPEG
          break
        case '47494638':
          metadata.type = FileType.GIF
          break
        default:
          metadata.type = FileType.UNSUPPORTED
          break
      }

      resolve(metadata)
    }

    reader.readAsArrayBuffer(file.slice(0, 4))
  })
}
