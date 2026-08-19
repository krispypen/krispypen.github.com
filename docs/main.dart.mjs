// Compiles a dart2wasm-generated main module from `source` which can then
// be instantiated via the `instantiate` method.
//
// `source` needs to be a `Response` object (or promise thereof) e.g. created
// via the `fetch()` JS API.
export async function compileStreaming(source) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(
      await WebAssembly.compileStreaming(source, builtins), builtins);
}

// Compiles a dart2wasm-generated wasm module from `bytes` which is then
// instantiable via the `instantiate` method.
export async function compile(bytes) {
  const builtins = {builtins: ['js-string']};
  return new CompiledApp(await WebAssembly.compile(bytes, builtins), builtins);
}

class CompiledApp {
  constructor(module, builtins) {
    this.module = module;
    this.builtins = builtins;
  }

  // The second argument is an options object containing:
  // `loadDeferredModules` is a JS function that takes an array of module names
  //   matching wasm files produced by the dart2wasm compiler. It also takes a
  //   callback that should be invoked for each loaded module with 2 arguments:
  //   (1) the module name, (2) the loaded module in a format supported by
  //   `WebAssembly.compile` or `WebAssembly.compileStreaming`. The callback
  //   returns a Promise that resolves when the module is instantiated.
  //   loadDeferredModules should return a Promise that resolves when all the
  //   modules have been loaded and the callback promises have resolved.
  // `loadDeferredId` is a JS function that takes load ID produced by the
  //   compiler when the `use-load-ids` option is passed. Each load ID maps to
  //   one or more wasm files as specified in the emitted JSON file. It also
  //   takes a callback that should be invoked for each loaded module with 2
  //   arguments: (1) the module name, (2) the loaded module in a format
  //   supported by `WebAssembly.compile` or `WebAssembly.compileStreaming`.
  //   The callback returns a Promise that resolves when the module is
  //   instantiated.
  //   loadDeferredId should return a Promise that resolves when all the
  //   modules have been loaded and the callback promises have resolved.
  async instantiate(additionalImports, {loadDeferredModules, loadDeferredId} = {}) {
    let dartInstance;

    // Prints to the console
    function printToConsole(value) {
      if (typeof dartPrint == "function") {
        dartPrint(value);
        return;
      }
      if (typeof console == "object" && typeof console.log != "undefined") {
        console.log(value);
        return;
      }
      if (typeof print == "function") {
        print(value);
        return;
      }

      throw "Unable to print message: " + value;
    }

    // A special symbol attached to functions that wrap Dart functions.
    const jsWrappedDartFunctionSymbol = Symbol("JSWrappedDartFunction");

    function finalizeWrapper(dartFunction, wrapped) {
      wrapped.dartFunction = dartFunction;
      wrapped[jsWrappedDartFunctionSymbol] = true;
      return wrapped;
    }

    // Imports
    const dart2wasm = {
            AB: o => o,
      AC: (t, s) => t.set(s),
      AD: (x0,x1) => x0.append(x1),
      AE: (x0,x1) => x0.attachShadow(x1),
      AF: x0 => x0.click(),
      AG: x0 => x0.hasFocus(),
      AH: x0 => x0.width,
      AI: (x0,x1) => x0.append(x1),
      AJ: x0 => x0.id,
      AK: x0 => x0.ctrlKey,
      B: s => printToConsole(s),
      BB: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'boolean') return 1;
        return 2;
      },
      BC: Function.prototype.call.bind(DataView.prototype.setFloat32),
      BD: (x0,x1) => { x0.textContent = x1 },
      BE: x0 => x0.preventDefault(),
      BF: (x0,x1) => x0.getElementsByClassName(x1),
      BG: x0 => x0.shiftKey,
      BH: x0 => x0.clientWidth,
      BI: (x0,x1,x2) => x0.insertRule(x1,x2),
      BJ: x0 => x0.offsetHeight,
      BK: (x0,x1) => x0.getAttribute(x1),
      C: Function.prototype.call.bind(Number.prototype.toString),
      CB: (a, i, v) => a[i] = v,
      CC: Function.prototype.call.bind(DataView.prototype.getFloat32),
      CD: (ms, c) =>
      setTimeout(() => dartInstance.exports.$invokeCallback(c),ms),
      CE: (x0,x1) => x0.contains(x1),
      CF: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      CG: x0 => x0.visibilityState,
      CH: (x0,x1) => x0.removeChild(x1),
      CI: (x0,x1) => x0.add(x1),
      CJ: x0 => x0.offsetWidth,
      CK: (x0,x1) => x0.closest(x1),
      D: Function.prototype.call.bind(BigInt.prototype.toString),
      DB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI8ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      DC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float32Array) return 1;
        return 2;
      },
      DD: x0 => x0.parentElement,
      DE: (x0,x1) => x0.focus(x1),
      DF: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmF64ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      DG: x0 => x0.disconnect(),
      DH: x0 => x0.firstChild,
      DI: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      DJ: x0 => x0.stopPropagation(),
      DK: x0 => x0.tagName,
      E: (exn) => {
        let stackString = exn.toString();
        let frames = stackString.split('\n');
        let drop = 4;
        if (frames[0].startsWith('Error')) {
            drop += 1;
        }
        return frames.slice(drop).join('\n');
      },
      EB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const setValue = dartInstance.exports.$wasmI32ArraySet;
        for (let i = 0; i < length; i++) {
          setValue(wasmArray, wasmArrayOffset + i, jsArray[jsArrayOffset + i]);
        }
      },
      EC: Function.prototype.call.bind(DataView.prototype.getUint32),
      ED: (x0,x1) => x0.querySelectorAll(x1),
      EE: (x0,x1) => x0.closest(x1),
      EF: (x0,x1) => x0.contains(x1),
      EG: x0 => new Intl.Locale(x0),
      EH: x0 => x0.viewConstraints,
      EI: (x0,x1,x2) => x0.addEventListener(x1,x2),
      EJ: x0 => x0.disabled,
      EK: x0 => x0.target,
      F: () => new Error().stack,
      FB: Function.prototype.call.bind(String.prototype.toLowerCase),
      FC: Function.prototype.call.bind(DataView.prototype.setUint32),
      FD: x0 => x0.length,
      FE: (x0,x1) => x0.getAttribute(x1),
      FF: (s) => +s,
      FG: x0 => x0.region,
      FH: x0 => x0.hostElement,
      FI: x0 => x0.preventDefault(),
      FJ: (x0,x1) => { x0.min = x1 },
      FK: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      G: s => JSON.stringify(s),
      GB: (o, p, r) => o.replaceAll(p, () => r),
      GC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint32Array) return 1;
        return 2;
      },
      GD: (x0,x1) => x0.item(x1),
      GE: x0 => x0.activeElement,
      GF: x0 => x0.target,
      GG: x0 => x0.script,
      GH: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      GI: x0 => x0.createRange(),
      GJ: (x0,x1) => { x0.max = x1 },
      GK: (x0,x1,x2,x3) => x0.removeEventListener(x1,x2,x3),
      H: Function.prototype.call.bind(Number.prototype.toString),
      HB: (x0,x1) => x0[x1],
      HC: Function.prototype.call.bind(DataView.prototype.getInt32),
      HD: x0 => x0.userAgent,
      HE: (x0,x1) => x0.add(x1),
      HF: (x0,x1) => x0.dispatchEvent(x1),
      HG: x0 => x0.language,
      HH: x0 => ({runApp: x0}),
      HI: (x0,x1) => x0.selectNode(x1),
      HJ: (x0,x1) => { x0.disabled = x1 },
      HK: () => globalThis.window,
      I: Function.prototype.call.bind(String.prototype.indexOf),
      IB: x0 => x0.length,
      IC: Function.prototype.call.bind(DataView.prototype.setInt32),
      ID: x0 => x0.maxTouchPoints,
      IE: x0 => x0.classList,
      IF: (x0,x1) => x0.createEvent(x1),
      IG: x0 => x0.languages,
      IH: Function.prototype.call.bind(DataView.prototype.setBigInt64),
      II: x0 => x0.getSelection(),
      IJ: (x0,x1) => { x0.scrollLeft = x1 },
      IK: x0 => x0.length,
      J: (s, p, i) => s.lastIndexOf(p, i),
      JB: (x0,x1) => x0.exec(x1),
      JC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int32Array) return 1;
        return 2;
      },
      JD: x0 => x0.platform,
      JE: x0 => x0.data,
      JF: (x0,x1,x2,x3) => x0.initEvent(x1,x2,x3),
      JG: (x0,x1) => x0.observe(x1),
      JH: Function.prototype.call.bind(DataView.prototype.getBigInt64),
      JI: x0 => x0.removeAllRanges(),
      JJ: (x0,x1) => { x0.spellcheck = x1 },
      JK: x0 => x0.getReader(),
      K: (exn) => {
        if (exn instanceof Error) {
          return exn.stack;
        } else {
          return null;
        }
      },
      KB: x0 => x0.flags,
      KC: o => o instanceof Uint16Array,
      KD: x0 => x0.navigator,
      KE: x0 => x0.scrollTop,
      KF: () => globalThis.window,
      KG: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      KH: (o, start, length) => new BigInt64Array(o.buffer, o.byteOffset + start, length),
      KI: (x0,x1) => x0.addRange(x1),
      KJ: (x0,x1) => { x0.disabled = x1 },
      KK: x0 => x0.value,
      L: o => o === undefined,
      LB: (s, m) => {
        try {
          return new RegExp(s, m);
        } catch (e) {
          return String(e);
        }
      },
      LC: Function.prototype.call.bind(DataView.prototype.getUint16),
      LD: s => new Date(s * 1000).getTimezoneOffset() * 60,
      LE: (handle) => clearTimeout(handle),
      LF: x0 => x0.readText(),
      LG: x0 => new ResizeObserver(x0),
      LH: () => typeof dartUseDateNowForTicks !== "undefined",
      LI: () => globalThis.window,
      LJ: (x0,x1) => x0.transferFromImageBitmap(x1),
      LK: x0 => x0.done,
      M: o => String(o),
      MB: o => o instanceof RegExp,
      MC: Function.prototype.call.bind(DataView.prototype.setUint16),
      MD: Date.now,
      ME: (x0,x1) => { x0.scrollTop = x1 },
      MF: x0 => x0.clipboard,
      MG: x0 => globalThis.parseFloat(x0),
      MH: () => Date.now(),
      MI: (x0,x1) => { x0.innerText = x1 },
      MJ: (x0,x1) => x0.getContext(x1),
      MK: x0 => x0.read(),
      N: (c) =>
      queueMicrotask(() => dartInstance.exports.$invokeCallback(c)),
      NB: s => s.trim(),
      NC: o => o instanceof Int16Array,
      ND: (x0,x1,x2) => x0.setAttribute(x1,x2),
      NE: x0 => x0.tagName,
      NF: (x0,x1) => x0.writeText(x1),
      NG: (x0,x1) => x0.getComputedStyle(x1),
      NH: () => 1000 * performance.now(),
      NI: x0 => x0.offsetY,
      NJ: (x0,x1) => { x0.height = x1 },
      NK: x0 => x0.body,
      O: (x0,x1) => x0.didCreateEngineInitializer(x1),
      OB: (a, s) => a.join(s),
      OC: Function.prototype.call.bind(DataView.prototype.getInt16),
      OD: (x0,x1,x2,x3) => x0.setProperty(x1,x2,x3),
      OE: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      OF: x0 => x0.unlock(),
      OG: x0 => x0.documentElement,
      OH: x0 => new Uint8Array(x0),
      OI: x0 => x0.offsetX,
      OJ: (x0,x1) => { x0.width = x1 },
      OK: (x0,x1) => new OffscreenCanvas(x0,x1),
      P: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      PB: (x0,x1) => x0.error(x1),
      PC: Function.prototype.call.bind(DataView.prototype.setInt16),
      PD: x0 => x0.style,
      PE: (x0,x1) => { x0.value = x1 },
      PF: (x0,x1) => x0.lock(x1),
      PG: x0 => x0.computedStyleMap(),
      PH: (x0,x1,x2) => x0.slice(x1,x2),
      PI: x0 => x0.button,
      PJ: x0 => x0.height,
      PK: x0 => x0.assetBase,
      Q: (wasmFunction,f) => finalizeWrapper(f, function() { return wasmFunction(f,arguments.length) }),
      QB: () => globalThis.console,
      QC: o => o instanceof Uint8ClampedArray,
      QD: (x0,x1) => x0.createElement(x1),
      QE: (x0,x1,x2) => x0.setSelectionRange(x1,x2),
      QF: x0 => x0.orientation,
      QG: (x0,x1) => x0.get(x1),
      QH: (x0,x1) => x0.decode(x1),
      QI: x0 => x0.classList,
      QJ: x0 => x0.width,
      QK: x0 => x0.loader,
      R: (x0,x1) => ({initializeEngine: x0,autoStart: x1}),
      RB: s => s.trimRight(),
      RC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Uint8Array) return 1;
        return 2;
      },
      RD: x0 => x0.body,
      RE: (x0,x1) => { x0.value = x1 },
      RF: (x0,x1) => x0.querySelector(x1),
      RG: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      RH: (x0,x1) => x0.adoptText(x1),
      RI: (x0,x1) => { x0.height = x1 },
      RJ: x0 => x0.rasterEndMilliseconds,
      RK: () => globalThis._flutter,
      S: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      SB: (x0,x1,x2,x3) => x0.pushState(x1,x2,x3),
      SC: Function.prototype.call.bind(DataView.prototype.setInt8),
      SD: x0 => x0.remove(),
      SE: x0 => x0.relatedTarget,
      SF: (x0,x1) => { x0.content = x1 },
      SG: x0 => x0.matches,
      SH: x0 => x0.first(),
      SI: (x0,x1) => { x0.width = x1 },
      SJ: x0 => x0.rasterStartMilliseconds,
      T: x0 => new Promise(x0),
      TB: () => ({}),
      TC: Function.prototype.call.bind(DataView.prototype.getInt8),
      TD: (x0,x1) => x0.getPropertyValue(x1),
      TE: x0 => x0.index,
      TF: x0 => x0.head,
      TG: (x0,x1) => x0.matchMedia(x1),
      TH: x0 => x0.next(),
      TI: x0 => x0.style,
      TJ: x0 => x0.imageBitmaps,
      U: (x0,x1,x2) => x0.call(x1,x2),
      UB: (o, p, v) => o[p] = v,
      UC: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Int8Array) return 1;
        return 2;
      },
      UD: (x0,x1) => x0.warn(x1),
      UE: x0 => x0.unicode,
      UF: (x0,x1) => { x0.name = x1 },
      UG: x0 => x0.matches,
      UH: x0 => x0.current(),
      UI: x0 => x0.sheet,
      UJ: x0 => x0.canvasKitMaximumSurfaces,
      V: (constructor, args) => {
        const factoryFunction = constructor.bind.apply(
            constructor, [null, ...args]);
        return new factoryFunction();
      },
      VB: () => [],
      VC: (o, start, length) => new Float64Array(o.buffer, o.byteOffset + start, length),
      VD: x0 => x0.console,
      VE: (x0,x1) => { x0.lastIndex = x1 },
      VF: (x0,x1) => { x0.title = x1 },
      VG: x0 => x0.timeStamp,
      VH: (x0,x1) => new Intl.v8BreakIterator(x0,x1),
      VI: x0 => x0.head,
      VJ: x0 => x0.nextSibling,
      W: x0 => new Array(x0),
      WB: (a, i) => a.push(i),
      WC: (o, start, length) => new Float32Array(o.buffer, o.byteOffset + start, length),
      WD: (x0,x1) => { x0.id = x1 },
      WE: x0 => x0.dotAll,
      WF: () => globalThis.document,
      WG: (x0,x1) => x0.hasAttribute(x1),
      WH: x0 => x0.v8BreakIterator,
      WI: () => globalThis.document,
      WJ: (x0,x1) => x0.debug(x1),
      X: o => [o],
      XB: b => !!b,
      XC: (o, start, length) => new Uint32Array(o.buffer, o.byteOffset + start, length),
      XD: (x0,x1) => x0.requestAnimationFrame(x1),
      XE: x0 => x0.ignoreCase,
      XF: (x0,x1) => x0.vibrate(x1),
      XG: x0 => x0.buttons,
      XH: () => globalThis.Intl,
      XI: (x0,x1) => x0.revokeObjectURL(x1),
      XJ: x0 => x0.hostElement,
      Y: (o0, o1) => [o0, o1],
      YB: x0 => new Int8Array(x0),
      YC: (o, start, length) => new Int32Array(o.buffer, o.byteOffset + start, length),
      YD: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      YE: x0 => x0.multiline,
      YF: (o, p) => p in o,
      YG: x0 => x0.ctrlKey,
      YH: (x0,x1) => x0.segment(x1),
      YI: (x0,x1) => { x0.src = x1 },
      YJ: x0 => x0.location,
      Z: (o0, o1, o2) => [o0, o1, o2],
      ZB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI8ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      ZC: (o, start, length) => new Uint16Array(o.buffer, o.byteOffset + start, length),
      ZD: x0 => x0.now(),
      ZE: s => {
        if (/[[\]{}()*+?.\\^$|]/.test(s)) {
            s = s.replace(/[[\]{}()*+?.\\^$|]/g, '\\$&');
        }
        return s;
      },
      ZF: x0 => x0.arrayBuffer(),
      ZG: x0 => x0.y,
      ZH: x0 => x0.index,
      ZI: (x0,x1,x2,x3,x4) => globalThis.createImageBitmap(x0,x1,x2,x3,x4),
      ZJ: (x0,x1) => x0.getModifierState(x1),
      a: (o0, o1, o2, o3) => [o0, o1, o2, o3],
      aB: x0 => new Uint8Array(x0),
      aC: (o, start, length) => new Int16Array(o.buffer, o.byteOffset + start, length),
      aD: x0 => x0.performance,
      aE: x0 => x0.value,
      aF: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof ArrayBuffer) return 1;
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
          return 2;
        }
        return 3;
      },
      aG: x0 => x0.x,
      aH: x0 => x0.next(),
      aI: x0 => x0.naturalHeight,
      aJ: x0 => x0.metaKey,
      b: (x0,x1,x2) => { x0[x1] = x2 },
      bB: x0 => new Uint8ClampedArray(x0),
      bC: (o, start, length) => new Uint8ClampedArray(o.buffer, o.byteOffset + start, length),
      bD: (x0,x1) => x0.unregister(x1),
      bE: x0 => x0.selectionDirection,
      bF: x0 => x0.status,
      bG: x0 => x0.offsetTop,
      bH: x0 => x0.value,
      bI: x0 => x0.naturalWidth,
      bJ: x0 => x0.altKey,
      c: o => o,
      cB: x0 => new Int16Array(x0),
      cC: (o, start, length) => new Int8Array(o.buffer, o.byteOffset + start, length),
      cD: () => globalThis.window.FinalizationRegistry,
      cE: x0 => x0.selectionStart,
      cF: (x0,x1) => x0.fetch(x1),
      cG: x0 => x0.scrollLeft,
      cH: x0 => x0.done,
      cI: x0 => x0.decode(),
      cJ: x0 => x0.ctrlKey,
      d: (o, p) => o[p],
      dB: x0 => new Uint16Array(x0),
      dC: x0 => x0.history,
      dD: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      dE: x0 => x0.selectionEnd,
      dF: x0 => x0.content,
      dG: x0 => x0.offsetLeft,
      dH: (o, m, a) => o[m].apply(o, a),
      dI: (x0,x1) => { x0.decoding = x1 },
      dJ: x0 => x0.isComposing,
      e: () => globalThis,
      eB: x0 => new Int32Array(x0),
      eC: x0 => x0.search,
      eD: x0 => new window.FinalizationRegistry(x0),
      eE: x0 => x0.value,
      eF: x0 => x0.document,
      eG: x0 => x0.offsetParent,
      eH: x0 => x0.iterator,
      eI: (x0,x1) => { x0.crossOrigin = x1 },
      eJ: x0 => x0.code,
      f: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      fB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmI32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      fC: o => {
        if (o === null || o === undefined) return 0;
        if (typeof(o) === 'string') return 1;
        return 2;
      },
      fD: x0 => x0.scale,
      fE: x0 => x0.selectionDirection,
      fF: x0 => x0.language,
      fG: x0 => x0.deltaMode,
      fH: () => globalThis.Symbol,
      fI: (x0,x1) => x0.createObjectURL(x1),
      fJ: x0 => x0.repeat,
      g: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      gB: x0 => new Uint32Array(x0),
      gC: x0 => x0.location,
      gD: x0 => x0.visualViewport,
      gE: x0 => x0.selectionStart,
      gF: (x0,x1,x2,x3) => x0.register(x1,x2,x3),
      gG: x0 => x0.deltaY,
      gH: (x0,x1) => new Intl.Segmenter(x0,x1),
      gI: x0 => x0.URL,
      gJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      h: (x0,x1) => ({addView: x0,removeView: x1}),
      hB: x0 => new Float32Array(x0),
      hC: x0 => x0.pathname,
      hD: x0 => x0.devicePixelRatio,
      hE: x0 => x0.selectionEnd,
      hF: (x0,x1) => x0.prepend(x1),
      hG: x0 => x0.deltaX,
      hH: x0 => x0.Segmenter,
      hI: x0 => new Blob(x0),
      hJ: x0 => x0.userAgent,
      i: (l, r) => l === r,
      iB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF32ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      iC: (x0,x1,x2,x3) => x0.replaceState(x1,x2,x3),
      iD: (d, digits) => d.toFixed(digits),
      iE: x0 => x0.keyCode,
      iF: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      iG: x0 => x0.wheelDeltaY,
      iH: x0 => x0.buffer,
      iI: (x0,x1,x2,x3,x4) => ({type: x0,data: x1,premultiplyAlpha: x2,colorSpaceConversion: x3,preferAnimation: x4}),
      iJ: x0 => x0.navigator,
      j: x0 => x0.random(),
      jB: x0 => new Float64Array(x0),
      jC: o => {
        const proto = Object.getPrototypeOf(o);
        return proto === Object.prototype || proto === null;
      },
      jD: x0 => x0.maxHeight,
      jE: (x0,x1) => x0.scrollIntoView(x1),
      jF: (x0,x1) => x0.querySelector(x1),
      jG: x0 => x0.wheelDeltaX,
      jH: x0 => x0.wasmMemory,
      jI: x0 => new window.ImageDecoder(x0),
      jJ: (x0,x1,x2,x3) => x0.open(x1,x2,x3),
      k: o => o,
      kB: (jsArray, jsArrayOffset, wasmArray, wasmArrayOffset, length) => {
        const getValue = dartInstance.exports.$wasmF64ArrayGet;
        for (let i = 0; i < length; i++) {
          jsArray[jsArrayOffset + i] = getValue(wasmArray, wasmArrayOffset + i);
        }
      },
      kC: o => Object.keys(o),
      kD: x0 => x0.maxWidth,
      kE: x0 => x0.multiViewEnabled,
      kF: (x0,x1) => x0.querySelectorAll(x1),
      kG: x0 => x0.key,
      kH: () => globalThis.window._flutter_skwasmInstance,
      kI: x0 => x0.name,
      kJ: (x0,x1,x2) => x0.setAttribute(x1,x2),
      l: o => {
        if (o === undefined || o === null) return 0;
        if (typeof o === 'number') return 1;
        return 2;
      },
      lB: x0 => new ArrayBuffer(x0),
      lC: o => typeof o === 'function' && o[jsWrappedDartFunctionSymbol] === true,
      lD: x0 => x0.minHeight,
      lE: x0 => x0.parent,
      lF: x0 => x0.tabIndex,
      lG: x0 => x0.identifier,
      lH: () => new TextDecoder(),
      lI: x0 => x0.repetitionCount,
      lJ: (x0,x1) => x0.createElement(x1),
      m: () => globalThis.Math,
      mB: (x0,x1,x2) => new Uint8Array(x0,x1,x2),
      mC: f => f.dartFunction,
      mD: x0 => x0.minWidth,
      mE: (x0,x1) => x0.replaceWith(x1),
      mF: x0 => x0.parentNode,
      mG: x0 => x0.touches,
      mH: (a, i) => a.splice(i, 1),
      mI: x0 => x0.frameCount,
      mJ: (x0,x1) => { x0.cursor = x1 },
      n: (string, token) => string.split(token),
      nB: (x0,x1,x2) => new DataView(x0,x1,x2),
      nC: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      nD: x0 => x0.height,
      nE: (x0,x1) => { x0.type = x1 },
      nF: x0 => x0.clientY,
      nG: x0 => x0.pressure,
      nH: a => a.pop(),
      nI: x0 => x0.selectedTrack,
      nJ: (x0,x1) => { x0.height = x1 },
      o: o => o instanceof Array,
      oB: (o, p) => o[p],
      oC: (wasmFunction,f) => finalizeWrapper(f, function(x0,x1) { return wasmFunction(f,arguments.length,x0,x1) }),
      oD: x0 => x0.width,
      oE: (x0,x1) => { x0.className = x1 },
      oF: x0 => x0.clientX,
      oG: x0 => x0.tiltY,
      oH: (map, o, v) => map.set(o, v),
      oI: x0 => x0.completed,
      oJ: (x0,x1) => { x0.width = x1 },
      p: (a, i) => a[i],
      pB: (o) => new DataView(o.buffer, o.byteOffset, o.byteLength),
      pC: (p, s, f) => p.then(s, (e) => f(e, e === undefined)),
      pD: x0 => x0.screen,
      pE: (x0,x1) => { x0.tabIndex = x1 },
      pF: x0 => x0.getBoundingClientRect(),
      pG: x0 => x0.tiltX,
      pH: (map, o) => map.get(o),
      pI: x0 => x0.ready,
      pJ: (x0,x1) => { x0.display = x1 },
      q: a => a.length,
      qB: Function.prototype.call.bind(Object.getOwnPropertyDescriptor(DataView.prototype, 'byteLength').get),
      qC: (o, i) => o[i],
      qD: s => {
        if (!/^\s*[+-]?(?:Infinity|NaN|(?:\.\d+|\d+(?:\.\d*)?)(?:[eE][+-]?\d+)?)\s*$/.test(s)) {
          return NaN;
        }
        return parseFloat(s);
      },
      qE: (x0,x1) => { x0.name = x1 },
      qF: x0 => x0.bottom,
      qG: x0 => x0.pointerType,
      qH: () => new WeakMap(),
      qI: x0 => x0.tracks,
      qJ: (x0,x1) => { x0.opacity = x1 },
      r: (string, times) => string.repeat(times),
      rB: Function.prototype.call.bind(DataView.prototype.setFloat64),
      rC: o => o.length,
      rD: (x0,x1) => x0.removeProperty(x1),
      rE: (x0,x1) => { x0.placeholder = x1 },
      rF: x0 => x0.top,
      rG: x0 => x0.pointerId,
      rH: x0 => new WeakRef(x0),
      rI: x0 => x0.close(),
      rJ: x0 => x0.style,
      s: (decoder, codeUnits) => decoder.decode(codeUnits),
      sB: o => o.byteOffset,
      sC: o => {
        if (o === undefined) return 1;
        var type = typeof o;
        if (type === 'boolean') return 2;
        if (type === 'number') return 3;
        if (type === 'string') return 4;
        if (o instanceof Array) return 5;
        if (ArrayBuffer.isView(o)) {
          if (o instanceof Int8Array) return 6;
          if (o instanceof Uint8Array) return 7;
          if (o instanceof Uint8ClampedArray) return 8;
          if (o instanceof Int16Array) return 9;
          if (o instanceof Uint16Array) return 10;
          if (o instanceof Int32Array) return 11;
          if (o instanceof Uint32Array) return 12;
          if (o instanceof Float32Array) return 13;
          if (o instanceof Float64Array) return 14;
          if (o instanceof DataView) return 15;
        }
        if (o instanceof ArrayBuffer) return 16;
        // Feature check for `SharedArrayBuffer` before doing a type-check.
        if (globalThis.SharedArrayBuffer !== undefined &&
            o instanceof SharedArrayBuffer) {
            return 17;
        }
        if (o instanceof Promise) return 18;
        return 19;
      },
      sD: (x0,x1) => x0.appendChild(x1),
      sE: (x0,x1) => { x0.autocomplete = x1 },
      sF: x0 => x0.right,
      sG: x0 => x0.getCoalescedEvents(),
      sH: x0 => x0.deref(),
      sI: (x0,x1) => ({frameIndex: x0,completeFramesOnly: x1}),
      sJ: (o, p, v) => o[p] = v,
      t: (o, start, length) => new Uint8Array(o.buffer, o.byteOffset + start, length),
      tB: o => o.buffer,
      tC: x0 => x0.state,
      tD: x0 => x0.debugShowSemanticsNodes,
      tE: (x0,x1) => { x0.name = x1 },
      tF: x0 => x0.left,
      tG: (x0,x1) => x0.getModifierState(x1),
      tH: () => globalThis.WeakRef,
      tI: (x0,x1) => x0.decode(x1),
      tJ: () => globalThis.document,
      u: () => new TextDecoder("utf-8", {fatal: true}),
      uB: (b, o) => new DataView(b, o),
      uC: x0 => x0.hash,
      uD: (o, c) => o instanceof c,
      uE: (x0,x1) => { x0.placeholder = x1 },
      uF: x0 => x0.clientY,
      uG: x0 => x0.blur(),
      uH: x0 => x0.debugSkipFontRetryDelay,
      uI: x0 => x0.displayHeight,
      uJ: (x0,x1,x2,x3) => x0.addEventListener(x1,x2,x3),
      v: () => new TextDecoder("utf-8", {fatal: false}),
      vB: (b, o, l) => new DataView(b, o, l),
      vC: (x0,x1,x2) => x0.removeEventListener(x1,x2),
      vD: x0 => x0.vendor,
      vE: (x0,x1) => { x0.action = x1 },
      vF: x0 => x0.clientX,
      vG: x0 => x0.button,
      vH: (x0,x1,x2) => x0.set(x1,x2),
      vI: x0 => x0.displayWidth,
      vJ: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      w: s => s.trimLeft(),
      wB: Function.prototype.call.bind(DataView.prototype.getUint8),
      wC: (wasmFunction,f) => finalizeWrapper(f, function(x0) { return wasmFunction(f,arguments.length,x0) }),
      wD: (x0,x1) => x0.createTextNode(x1),
      wE: (x0,x1) => { x0.method = x1 },
      wF: x0 => x0.changedTouches,
      wG: x0 => x0.innerHeight,
      wH: x0 => x0.fontFallbackBaseUrl,
      wI: x0 => x0.duration,
      wJ: x0 => x0.preventDefault(),
      x: s => s.toUpperCase(),
      xB: Function.prototype.call.bind(DataView.prototype.setUint8),
      xC: x0 => x0.state,
      xD: (x0,x1) => { x0.nonce = x1 },
      xE: (x0,x1) => { x0.noValidate = x1 },
      xF: x0 => x0.offsetY,
      xG: x0 => x0.height,
      xH: (o, offsetInBytes, lengthInBytes) => {
        var dst = new ArrayBuffer(lengthInBytes);
        new Uint8Array(dst).set(new Uint8Array(o, offsetInBytes, lengthInBytes));
        return new DataView(dst);
      },
      xI: x0 => x0.image,
      xJ: x0 => x0.shiftKey,
      y: Object.is,
      yB: Function.prototype.call.bind(DataView.prototype.getFloat64),
      yC: (x0,x1,x2) => x0.addEventListener(x1,x2),
      yD: x0 => x0.nonce,
      yE: (x0,x1) => x0.removeAttribute(x1),
      yF: x0 => x0.offsetX,
      yG: x0 => x0.clientHeight,
      yH: (a, s, e) => a.slice(s, e),
      yI: () => globalThis.window.ImageDecoder,
      yJ: x0 => x0.metaKey,
      z: (x0,x1) => x0.test(x1),
      zB: o => {
        if (o === null || o === undefined) return 0;
        if (o instanceof Float64Array) return 1;
        return 2;
      },
      zC: (x0,x1) => x0.go(x1),
      zD: () => globalThis.window.flutterConfiguration,
      zE: x0 => x0.isConnected,
      zF: x0 => x0.type,
      zG: x0 => x0.innerWidth,
      zH: (x0,x1) => x0.createElement(x1),
      zI: (x0,x1,x2) => x0.insertBefore(x1,x2),
      zJ: x0 => x0.altKey,

    };

    const baseImports = {
      _: dart2wasm,
      Math: Math,
      Date: Date,
      Object: Object,
      Array: Array,
      Reflect: Reflect,
      WebAssembly: {
        JSTag: WebAssembly.JSTag,
      },
      "": new Proxy({}, { get(_, prop) { return prop; } }),

    };

    const jsStringPolyfill = {
      "charCodeAt": (s, i) => s.charCodeAt(i),
      "compare": (s1, s2) => {
        if (s1 < s2) return -1;
        if (s1 > s2) return 1;
        return 0;
      },
      "concat": (s1, s2) => s1 + s2,
      "equals": (s1, s2) => s1 === s2,
      "fromCharCode": (i) => String.fromCharCode(i),
      "length": (s) => s.length,
      "substring": (s, a, b) => s.substring(a, b),
      "fromCharCodeArray": (a, start, end) => {
        if (end <= start) return '';

        const read = dartInstance.exports.$wasmI16ArrayGet;
        let result = '';
        let index = start;
        const chunkLength = Math.min(end - index, 500);
        let array = new Array(chunkLength);
        while (index < end) {
          const newChunkLength = Math.min(end - index, 500);
          for (let i = 0; i < newChunkLength; i++) {
            array[i] = read(a, index++);
          }
          if (newChunkLength < chunkLength) {
            array = array.slice(0, newChunkLength);
          }
          result += String.fromCharCode(...array);
        }
        return result;
      },
      "intoCharCodeArray": (s, a, start) => {
        if (s === '') return 0;

        const write = dartInstance.exports.$wasmI16ArraySet;
        for (var i = 0; i < s.length; ++i) {
          write(a, start++, s.charCodeAt(i));
        }
        return s.length;
      },
      "test": (s) => typeof s == "string",
    };


    

    dartInstance = await WebAssembly.instantiate(this.module, {
      ...baseImports,
      ...additionalImports,
      
      "wasm:js-string": jsStringPolyfill,
    });

    return new InstantiatedApp(this, dartInstance);
  }
}

class InstantiatedApp {
  constructor(compiledApp, instantiatedModule) {
    this.compiledApp = compiledApp;
    this.instantiatedModule = instantiatedModule;
  }

  // Call the main function with the given arguments.
  invokeMain(...args) {
    this.instantiatedModule.exports.$invokeMain(args);
  }
}
