@module("./Sidebar.module.css")
external styles: {..} = "default"

@val external document: 'a = "document"

module Range = {
  @react.component
  let make = (~label, ~name, ~min, ~max, ~value, ~onChange) => {
    let updateValue = (e: ReactEvent.Form.t) => {
      onChange(. ReactEvent.Form.target(e)["value"])
    }

    <div className={styles["option"]}>
      <input type_="range" id={name} name min max value onChange={updateValue} />
      <label htmlFor={name}> {React.string(label)} </label>
    </div>
  }
}

module ColorPicker = {
  @react.component
  let make = (~label, ~name, ~value, ~onChange) => {
    let updateValue = (e: ReactEvent.Form.t) => {
      onChange(. ReactEvent.Form.target(e)["value"])
    }

    <div className={styles["option"]}>
      <input type_="color" id={name} name value onChange={updateValue} />
      <label htmlFor={name}> {React.string(label)} </label>
    </div>
  }
}

@react.component
let make = () => {
  let root = React.useRef(document["documentElement"])
  let (buttonStyles, setButtonStyles) = React.Uncurried.useState(_ => Js.Dict.empty())

  let getSufixFromKey = key => {
    let suffix = if key != "color" && key != "background" {
      "px"
    } else {
      ""
    }

    suffix
  }

  let getOr = (~key, ~defaultValue="0", ()) => {
    switch Js.Dict.get(buttonStyles, key) {
    | Some(value) => value
    | None => defaultValue
    }
  }

  React.useEffect1(() => {
    let keys = Js.Dict.keys(buttonStyles)

    Js.Array2.forEach(keys, key => {
      root.current["style"]["setProperty"](
        "--" ++ key,
        Js.Dict.unsafeGet(buttonStyles, key) ++ getSufixFromKey(key),
      )
    })

    None
  }, [buttonStyles])

  let onChange = (~stateKey, . value) => {
    let stylesMap = buttonStyles
    Js.Dict.set(stylesMap, stateKey, value)
    setButtonStyles(._ => stylesMap->Js.Dict.entries->Js.Dict.fromArray)
  }

  <section className={styles["sidebar"]}>
    <Range
      label="Padding"
      name="padding"
      min="0"
      max="100"
      value={getOr(~key="padding", ())}
      onChange={onChange(~stateKey="padding")}
    />
    <Range
      label="Margin"
      name="margin"
      min="0"
      max="100"
      value={getOr(~key="margin", ())}
      onChange={onChange(~stateKey="margin")}
    />
    <Range
      label="Font size"
      name="fontSize"
      min="0"
      max="100"
      value={getOr(~key="font-size", ())}
      onChange={onChange(~stateKey="font-size")}
    />
    <Range
      label="Border radius"
      name="radius"
      min="0"
      max="100"
      value={getOr(~key="border-radius", ())}
      onChange={onChange(~stateKey="border-radius")}
    />
    <ColorPicker
      label="Color"
      name="color"
      value={getOr(~key="color", ~defaultValue="#000000", ())}
      onChange={onChange(~stateKey="color")}
    />
    <ColorPicker
      label="Background"
      name="background"
      value={getOr(~key="background", ~defaultValue="#ffffff", ())}
      onChange={onChange(~stateKey="background")}
    />
  </section>
}
