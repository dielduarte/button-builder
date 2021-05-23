@module("./Button.module.css")
external styles: {..} = "default"

@react.component
let make = () => {
  <button className={styles["button"]}> {React.string("hey")} </button>
}
