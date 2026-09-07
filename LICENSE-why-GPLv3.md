# Why choosing GPLv3 for developing Pulsar

Pharo is MIT licensed.

That makes sense for Pharo because it is a platform. People build applications and products on top of it, including closed-source ones, and they need to be able to modify and extend Pharo as part of that work without imposing Pharo's license on their own software.

Pulsar is different.

Pulsar is an IDE for Pharo. The fact that today it lives in the same image in which we develop our applications is mostly a technical detail — and one that will change with Pulsar 1.0. It does not make Pulsar part of the applications developed with it.

What I want to protect with GPLv3 is Pulsar itself.

You are free to use Pulsar for proprietary software. You are free to add inspectors, presenters, visualizations, and other application-specific tooling to your own objects. In particular, extensions built through NewTools, Spec, or other extension mechanisms are not "Pulsar code" merely because Pulsar discovers or uses them.

But if you modify Pulsar itself and distribute that modified version, I want the people receiving it to receive the same freedoms you received: the ability to study it, modify it, redistribute it, and build further improvements on top of it.

That is the reason for GPLv3.

I do not want Pulsar to become a piece of open-source software that can be taken, improved, redistributed as part of another product, and then closed again. If improvements to Pulsar are distributed, those improvements should remain free software as well.

This does not mean that every program written with Pulsar, every Pharo package loaded alongside it, or every tool that Pulsar can use suddenly becomes GPL. The boundary I care about is much simpler:

**software developed with Pulsar can use whatever license its authors choose; Pulsar itself, and distributed modifications of Pulsar, should remain free.**

In short, Pharo is MIT because it is a platform on which people should be able to build anything.

Pulsar is GPLv3 _because_ I want Pulsar itself to remain open, hackable, and available for the next person to study, improve, and modify.