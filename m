From: Sean Christopherson <sean.j.christopherson@intel.com>
To: Andy Lutomirski <luto@amacapital.net>
CC: Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>, "Hansen,
 Dave" <dave.hansen@intel.com>, Linus Torvalds
	<torvalds@linux-foundation.org>, Rich Felker <dalias@libc.org>, Dave Hansen
	<dave.hansen@linux.intel.com>, Jethro Beekman <jethro@fortanix.com>, Jarkko
 Sakkinen <jarkko.sakkinen@linux.intel.com>, Florian Weimer
	<fweimer@redhat.com>, Linux API <linux-api@vger.kernel.org>, X86 ML
	<x86@kernel.org>, linux-arch <linux-arch@vger.kernel.org>, LKML
	<linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	"nhorman@redhat.com" <nhorman@redhat.com>, "npmccallum@redhat.com"
	<npmccallum@redhat.com>, "Ayoun, Serge" <serge.ayoun@intel.com>,
	"Katz-zamir, Shay" <shay.katz-zamir@intel.com>, "linux-sgx@vger.kernel.org"
	<linux-sgx@vger.kernel.org>, Andy Shevchenko
	<andriy.shevchenko@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Carlos
 O'Donell <carlos@redhat.com>, "adhemerval.zanella@linaro.org"
	<adhemerval.zanella@linaro.org>
Subject: Re: RFC: userspace exception fixups
Sender: "linux-kernel-owner@vger.kernel.org"
	<linux-kernel-owner@vger.kernel.org>
Date: Tue, 6 Nov 2018 09:19:10 -0800
Message-ID: <1541524750.7839.51.camel@intel.com>
References: 
 <CAHk-=wiYSpmDOfpi9n7ETsxK2UrUKfT4kM=Y3yqRSaZuFFPY1A@mail.gmail.com>
         <CALCETrWe4+apXJNswHAKVVqajGS3jTEKxdd2r3iu-MzGK1v0DA@mail.gmail.com>
         <20181102163034.GB7393@linux.intel.com>
         <7050972d-a874-dc08-3214-93e81181da60@intel.com>
         <20181102170627.GD7393@linux.intel.com>
         <a4d2b3ec-43ec-f062-e180-c6e5a0d9fab8@intel.com>
         <20181102173350.GF7393@linux.intel.com>
         <CALCETrUQVPN0LSEz+5aNsbfFc=rQ33JHiOoRXVbvEEb9is9DDQ@mail.gmail.com>
         <20181102182712.GG7393@linux.intel.com>
         <CAG48ez0x7ZPcKvLt01WS-VrLm59WfvYE3nE1xbnyn3Qsp5T2rA@mail.gmail.com>
         <20181102220437.GI7393@linux.intel.com>
         <CAG48ez1+nGDbuBaKJVPAOzEwiBkXqHHs7vmyAqvbeM42r0nFHg@mail.gmail.com>
         <CALCETrXq1Kj=McxnPVjkscNq-b_7LeoFOdu7qKjHdvwcfFh9Og@mail.gmail.com>
         <1541518670.7839.31.camel@intel.com>
         <AF4A5C77-0A79-403F-A205-0F93B7CD6E26@amacapital.net>
In-Reply-To: <AF4A5C77-0A79-403F-A205-0F93B7CD6E26@amacapital.net>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
List-ID: <linux-sgx.vger.kernel.org>

T24gVHVlLCAyMDE4LTExLTA2IGF0IDA4OjU3IC0wODAwLCBBbmR5IEx1dG9taXJza2kgd3JvdGU6
DQo+DQo+IFNvIEkgZ3Vlc3MgdGhlIG5vbi1lbmNsYXZlIGNvZGUgYmFzaWNhbGx5IGNhbuKAmXQg
dHJ1c3QgaXRzIHN0YWNrIHBvaW50ZXINCj4gYmVjYXVzZSBvZiB0aGVzZSBzaGVuYW5pZ2Fucy4g
QW5kIHRoZSBBRVAgY29kZSBoYXMgdG8gbGl2ZSB3aXRoIHRoZSBmYWN0DQo+IHRoYXQgaXRzIFJT
UCBpcyBiYXNpY2FsbHkgYXJiaXRyYXJ5IGFuZCBwcm9iYWJseSBjYW7igJl0IGV2ZW4gYmUgdW53
b3VuZA0KPiBieSBhIGRlYnVnZ2VyPw0KDQpUaGUgU0RLIHByb3ZpZGVzIGEgUHl0aG9uIEdEQiBw
bHVnaW4gdG8gaG9vayBpbnRvIHRoZSBvdXQtY2FsbCBmbG93IGFuZA0KZG8gbW9yZSBzdGFjayBz
aGVuYW5pZ2Fucy7CoMKgRnJvbSB3aGF0IEkgY2FuIHRlbGwgaXQncyBmdWRnaW5nIHRoZSBzdGFj
aw0KdG8gbWFrZSBpdCBsb29rIGxpa2UgYSBub3JtYWwgc3RhY2sgZnJhbWUgc28gdGhlIGRlYnVn
Z2VyIGNhbiBkbyBpdCdzDQp0aGluZy4NCg0KPiBBbmQgdGhlIEVFTlRFUiBjb2RlIGhhcyB0byBk
ZWFsIHdpdGggdGhlIGZhY3QgdGhhdCBpdHMgcmVkIHpvbmUgY2FuIGJlDQo+IGJsYXRhbnRseSB2
aW9sYXRlZCBieSB0aGUgZW5jbGF2ZT8NCg0KVGhhdCdzIG15IHVuZGVyc3RhbmRpbmcgb2YgdGhp
bmdzLsKgwqBTbyB5ZWFoLCBpZiBpdCB3YXNuJ3Qgb2J2aW91cyBiZWZvcmUsDQp0aGUgdHJ1c3Rl
ZCBhbmQgdW50cnVzdGVkIHBhcnRzIG9mIHRoZSBTREsgYXJlIHZlcnkgdGlnaHRseSBjb3VwbGVk
Lg0K
