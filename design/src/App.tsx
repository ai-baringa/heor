//import React from 'react';
import logo from './logo.svg';
import * as _ from "lodash";
import './App.css';
import { DiagramEngine, DiagramModel, DefaultNodeModel, LinkModel, DiagramWidget, DefaultLinkModel } from "storm-react-diagrams";
import * as React from "react";
import { TrayWidget } from "./TrayWidget";
import { Application } from "./Application";
import { TrayItemWidget } from "./TrayItemWidget";
import { DemoWorkspaceWidget } from "./DemoWorkspaceWidget";
import { declareExportAllDeclaration } from '@babel/types';
import { action } from "@storybook/addon-actions";
var beautify = require("json-beautify");



require("storm-react-diagrams/dist/style.min.css");

export interface BodyWidgetProps {
	app: Application;
}

export interface BodyWidgetState {
	app: Application
}

/**
 * @author Siddhesh Dhuri
 */
export class BodyWidget extends React.Component<BodyWidgetProps, BodyWidgetState> {
	constructor(props: BodyWidgetProps) {
		super(props);
		this.state = {app: new Application};
	}

	handleSubmit = () => {
    	console.log('The link was clicked.');
	}

	render() {
		return (
			<div className="body">
				<div className="header">
					<div className="title">Health Economic Modeling</div>
				</div>
				<TrayWidget>
						<TrayItemWidget model={{ type: "in" }} name="Start State" color="rgb(66, 244, 170)" />
						<TrayItemWidget model={{ type: "out" }} name="End State" color="rgb(244, 65, 74)" />
						<TrayItemWidget model={{ type: "inout" }} name="Transition State" color="rgb(65, 196, 244)" />
						<button className='delete-button' onClick={() => { if (window.confirm('Submit model for evaluation')) this.handleSubmit() } } >
							Evaluate Model
						</button>
							
				</TrayWidget>
				<div className="content">
										
					<div
						className="diagram-layer"
						onDrop={event => {
							var data = JSON.parse(event.dataTransfer.getData("storm-diagram-node"));
							var nodesCount = _.keys(
								this.state.app
									.getDiagramEngine()
									.getDiagramModel()
									.getNodes()
							).length;

							var node = null;
							if (data.type === "in") {
								node = new DefaultNodeModel("Node " + (nodesCount + 1)+ " probability 0.1" , "rgb(66, 244, 170)");
								node.addOutPort("Out");
							} else if(data.type === "inout"){
								node = new DefaultNodeModel("Node " + (nodesCount + 1) + " probability 0.3", "rgb(65, 196, 244)", );
								node.addInPort("In");	
								node.addOutPort("Out");								
							} else {
								node = new DefaultNodeModel("Node " + (nodesCount + 1) + " probability 0.3", "rgb(244, 65, 74)");
								node.addInPort("In");
							}
							var points = this.state.app.getDiagramEngine().getRelativeMousePoint(event);
							node.x = points.x;
							node.y = points.y;
							node.addListener({selectionChanged: function(e){
								console.log(typeof(e.entity))
								}
							});
							this.state.app
								.getDiagramEngine()
								.getDiagramModel()
								.addNode(node);
							this.forceUpdate();
						}}
						onDragOver={event => {
							event.preventDefault();
						}}
					>
						<DemoWorkspaceWidget
							buttons={
								<button
									onClick={() => {
										console.log("XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX")
										console.log(beautify(this.state.app.getDiagramEngine().getDiagramModel().serializeDiagram(), null, 2, 80));
										(beautify(this.state.app.getDiagramEngine().getDiagramModel().serializeDiagram(), null, 2, 80));
									}}
								>
									Serialize Graph
								</button>
							}
						>
							<DiagramWidget className="srd-demo-canvas" diagramEngine={this.state.app.getDiagramEngine()} />
						</DemoWorkspaceWidget>						
						<div id='1234'>
							<img src="https://journals.plos.org/plosone/article/figure/image?id=10.1371/journal.pone.0047473.g004&size=large" width='50%'></img>
							<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/5/59/QALY_graph-en.svg/1280px-QALY_graph-en.svg.png" width='50%'></img>
						</div>
					</div>
				</div>
			</div>
		);
	}
}


export default BodyWidget;