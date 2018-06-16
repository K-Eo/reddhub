declare namespace Rails {
  export interface AjaxEvent {
    detail: [any, string, XMLHttpRequest]
  }

  export function fire(element: HTMLElement, event: string, data?: object): void
  export function disableElement(element: HTMLElement): void
  export function enableElement(element: HTMLElement): void
  export function ajax(options: object): void
}

declare module 'autosize' {
  interface API {
    (element: HTMLElement): void
    destroy(element: HTMLElement): void
  }

  let autosize: API

  export default autosize
}

declare module 'stimulus' {
  class DataMap {
    get(key: string): string | null
    set(key: string, value: any): string | null
    has(key: string): boolean
    delete(key: string): boolean
  }

  class TargetSet {
    has(targetName: string): boolean
    find(...targetNames: string[]): Element | undefined
    findAll(...targetNames: string[]): Element[]
  }

  export class Controller {
    data: DataMap
    element: Element
    identifier: string
    targets: TargetSet

    protected disconnect(): void
    protected connect(): void
    protected initialize(): void
  }
}

declare namespace Turbolinks {
  export interface TurbolinksAction {
    action: 'replace' | 'advance'
  }

  export function visit(location: string, action?: TurbolinksAction): void
  export function clearCache(): void
}

declare class Popper {
  constructor(a: HTMLElement, b: HTMLElement, options: object)
  destroy(): void
}

declare module 'croppie' {
  export class Croppie {
    constructor(element: HTMLElement, options: object)
    result(action: string): Promise<Blob>
  }

  export default Croppie
}
