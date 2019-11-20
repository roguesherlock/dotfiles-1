import { container, arrow, arrowLight, content } from './style.jsx';

import { run } from "uebersicht";

const yabai = "/usr/local/bin/yabai";

export const buttonClick = ({event}) => {
        console.log('Button was clicked!')
}


//https://github.com/benwr/barlioz/blob/master/widgets/workspaces.jsx
function makeSwitcher(n) {
  function swtch(e) {
    let cmd = yabai + ' -m space --focus ' + n;
    run(cmd);
    console.log(cmd);
    return false;
  }
  return swtch;
}

// This function manually sets the .left value to slide out divs
// consider adding a param to this function that indicates we should render a divider.
const renderDesktop = (d) => {
  let index = d.index;
  let visible = d.visible == 1;
  let focused = d.focused == 1;
  let contentStyle = JSON.parse(JSON.stringify(content));
	contentStyle.left = (index * 35 - 45) + 'px';
  let arrowStyle = JSON.parse(JSON.stringify(arrow));
	arrowStyle.left = (index * 35 - 10) + 'px';
  let arrowLightStyle = JSON.parse(JSON.stringify(arrowLight));
	arrowLightStyle.left = (index * 35 - 9) + 'px';
	if (visible) {
		contentStyle.background = 'rgba(235, 239, 243, 1)';
		contentStyle.color = 'rgba(76, 86, 106, 1)';
		arrowStyle.borderLeft = '10px solid rgba(235, 239, 243, 1)';
	}
      // TODO - do something cool if it's focused. maybe underline?
      // TODO - add click handlers (not SUPER needed...)
  return (
      <span onClick={makeSwitcher(index)}>
        <div style={contentStyle} onClick={makeSwitcher(index)}>
        {index}
        </div>
        <div style={arrowLightStyle}/>
        <div style={arrowStyle}/>
      </span>
  )
}

const renderDivider = () => {
  return(
      <span>
        <div style={content}>
        ...
        </div>
        <div style={arrowLight}/>
        <div style={arrow}/>
      </span>
  )
}

const render = ({output}) => {
  // console.log(`desktop data: ${output}`)
  if (typeof output === 'undefined') return null;
  // console.log(`desktop data: ${output.length}`)

  output = output.reverse();

  const desktops = [];
  const desktop1 = output.filter(l => {return l.display == 1})
  console.log(`desktop1 : ${desktop1}`)
  console.log(`desktop1 len : ${desktop1.length}`)

  // for (let num = output.end; num >= output.start; --num) {
  for (let i = 0; i < output.length; i++) {
    // console.log(`i: ${i}, focused: ${output[i].focused}, type: ${typeof(output[i].focused)}`)
    desktops.push(renderDesktop(output[i]));
    if (i + 1  == desktop1.length) {
      console.log(`pushing divider, index ${i}`)
      desktops.push(renderDivider());
    }
  }
  console.log(`left data: ${desktops}`)

  return (
    <div style={container}>
      {desktops}
    </div>
  )
}

export default render
