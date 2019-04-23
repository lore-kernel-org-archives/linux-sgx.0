Return-Path: <SRS0=01IT=SZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C7F2C10F03
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 21:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36750218B0
	for <linux-sgx@archiver.kernel.org>; Tue, 23 Apr 2019 21:15:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="o37SjqLo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfDWVP7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 23 Apr 2019 17:15:59 -0400
Received: from mail-eopbgr780108.outbound.protection.outlook.com ([40.107.78.108]:40640
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726083AbfDWVP6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 23 Apr 2019 17:15:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector1-fortanix-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XsfTfHTIOCQ/JUymmiLNl0/w6lEBIbtr6dJnFN6zcqo=;
 b=o37SjqLoxOYcnInA3W+7lK39oNQqBQjU+jxzBP+N0caTf9BBZNNLEVnwYpxrX3FUkt/rGPyjlIoMUb7Cg7cuBVMOxIbKGpG4CB39r33Skt0BbvaqvofESSa8v1SbYV6IjE/n82qaJvTmz0UDTgcQlE8yGVtpZRCkmN4FkgifFkk=
Received: from SN6PR11MB3167.namprd11.prod.outlook.com (52.135.109.144) by
 SN6PR11MB2734.namprd11.prod.outlook.com (52.135.92.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1813.12; Tue, 23 Apr 2019 21:15:51 +0000
Received: from SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::11b:a687:cd42:570d]) by SN6PR11MB3167.namprd11.prod.outlook.com
 ([fe80::11b:a687:cd42:570d%3]) with mapi id 15.20.1813.017; Tue, 23 Apr 2019
 21:15:51 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Andy Lutomirski <luto@kernel.org>
CC:     Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
Thread-Topic: [PATCH v20 00/28] Intel SGX1 support
Thread-Index: AQHU9QnkBhtGQ+66Y0uqVL4+2rp75qZCKU6AgAAN+gCAAVPlAIAAE4gAgABGE4CAABE+gIAAAfEAgAABGQCAAADeAIAABewAgAABNYCAAAN+gIAAAP2AgAAA3wCAAATggIAEWuOAgAHjMQA=
Date:   Tue, 23 Apr 2019 21:15:51 +0000
Message-ID: <4f39f6b1-21dd-4ed2-87a7-1e00f734708a@fortanix.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190418171059.GA20819@wind.enjellic.com>
 <09ebfa1d-c03d-c1fe-ff0f-d99287b6ec3c@intel.com>
 <20190419141732.GA2269@wind.enjellic.com>
 <CALCETrV=wAsyWxtxQJ7y0xNrzkE863hTfU6Ysej48Gk9yPFJZw@mail.gmail.com>
 <43aa8fdd-e777-74cb-e3f0-d36805ffa18b@fortanix.com>
 <alpine.DEB.2.21.1904192233390.3174@nanos.tec.linutronix.de>
 <8c5133bc-1301-24ca-418d-7151a6eac0e2@fortanix.com>
 <alpine.DEB.2.21.1904192248550.3174@nanos.tec.linutronix.de>
 <e1478f70-7e44-6e3e-2aaf-1b12a96328ed@fortanix.com>
 <2AE80EA3-799E-4808-BBE4-3872F425BCF8@amacapital.net>
 <49b28ca1-6e66-87d9-2202-84c58f13fb99@fortanix.com>
 <444537E3-4156-41FB-83CA-57C5B660523F@amacapital.net>
 <f9d93291-9b59-7b66-de9f-af92246f1c9c@fortanix.com>
 <alpine.DEB.2.21.1904192337160.3174@nanos.tec.linutronix.de>
 <5854e66a-950e-1b12-5393-d9cdd15367dc@fortanix.com>
 <CALCETrV7CcDnx1hVtmBnDNABG11GuMqyspJMMpV+zHpVeFu3ow@mail.gmail.com>
In-Reply-To: <CALCETrV7CcDnx1hVtmBnDNABG11GuMqyspJMMpV+zHpVeFu3ow@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR02CA0057.namprd02.prod.outlook.com
 (2603:10b6:a03:54::34) To SN6PR11MB3167.namprd11.prod.outlook.com
 (2603:10b6:805:c4::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [67.207.107.146]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 136ca691-dc3e-4723-2104-08d6c830dd10
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(7021145)(8989299)(4534185)(7022145)(4603075)(4627221)(201702281549075)(8990200)(7048125)(7024125)(7027125)(7023125)(5600141)(711020)(4605104)(2017052603328)(49563074)(7193020);SRVR:SN6PR11MB2734;
x-ms-traffictypediagnostic: SN6PR11MB2734:
x-microsoft-antispam-prvs: <SN6PR11MB2734B41FB80B1309A677EFB2AA230@SN6PR11MB2734.namprd11.prod.outlook.com>
x-forefront-prvs: 0016DEFF96
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(346002)(136003)(376002)(39850400004)(199004)(189003)(71190400001)(446003)(64756008)(66446008)(66556008)(966005)(31696002)(2906002)(6916009)(14454004)(102836004)(508600001)(26005)(186003)(11346002)(86362001)(66616009)(7416002)(73956011)(5660300002)(6116002)(66066001)(99936001)(66476007)(4326008)(97736004)(66946007)(3846002)(7736002)(305945005)(99286004)(52116002)(53936002)(6436002)(316002)(6246003)(2616005)(476003)(486006)(229853002)(53546011)(31686004)(6506007)(54906003)(386003)(6512007)(6306002)(76176011)(93886005)(25786009)(68736007)(8676002)(256004)(81166006)(8936002)(14444005)(81156014)(36756003)(71200400001)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR11MB2734;H:SN6PR11MB3167.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 0Vhwb/T/XdkHeOctl3n1ZOMDGTM6vHEY9KOAcUjeAOOSDPlpo5GNJIWoPDsBCdB0JFIgNPdFZ/nt4PzhI/dTfyv6mEen1E5FONrAEK2sdKI7KUQYKJVnTza5FyByhOx9AysdLs5EIIt5tLM6WQDXNl9X7WsJSDHlIqnCFNYW/MAb06LTErbsM9+WNHfMFqC/M9L8kwyy70YcrjM6iWu7tzz65H4yQ7jL8eFGGC/sH2kWhTT/OFTjaFuk33EEjcz9YOv7iB91GXqpi9bCtIpAI/oU1g190jIXZaAUfpoZkwaACRT51mjS8mVzNdk+idOLMkUc3crF4P7/MErr/j8+MUKbWLIyQ7C3K+fb7mtd0h6a/I9hnUU2aYnn8/s0Yt2X0Afctd29d7lKGQ3TVCaNZ/sTxIg4pYtQ/CPtOo0W46A=
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms080603040003010206000000"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 136ca691-dc3e-4723-2104-08d6c830dd10
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Apr 2019 21:15:51.5823
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2734
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms080603040003010206000000
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-04-22 09:26, Andy Lutomirski wrote:
>> On Apr 19, 2019, at 2:56 PM, Jethro Beekman <jethro@fortanix.com> wrot=
e:
>> This works fine with v20 as-is. However, consider the equivalent of th=
e
>> PT-based flow:
>>
>> mmap(PROT_READ|PROT_EXEC)
>> ioctl(EADD) <-- no error!
>=20
> Indeed!
>=20
>>
>> It's not me that's working around the LSM, it's the SGX driver! It's
>> writing to memory that's not marked writable! The fundamental issue he=
re
>> is that the SGX instruction set has several instructions that bypass t=
he
>> page table permission bits, and this is (naturally) confusing to any
>> kind of reference monitor like the LSM framework. You can come up with=

>> similar scenarios that involve PROT_READ|PROT_WRITE|PROT_EXEC or
>> ptrace(PTRACE_POKETEXT). So, clearly, the proper way to fix this failu=
re
>> of complete mediation is by enforcing appropriate page-table permissio=
ns
>> even on the SGX instructions that don't do it themselves. Just make an=
y
>> implicit memory access look like a regular memory access and now
>> everyone is on the same page (pun intended).
>>
>=20
> I agree that we should do this.  But then what?

Then, we have a minimum viable SGX implementation that doesn't make=20
things worse than they are today from a userspace code loading/LSM=20
perspective. People without LSMs can use SGX and people with LSMs are=20
not more vulnerable than before. I agree that we should do something=20
along the following lines...

> So I think we need a better EADD ioctl that explicitly does work on
> PROT_READ|PROT_EXEC enclave memory but makes up for by validating the
> *source* of the data.  The effect will be similar to mapping a
> labeled, appraised, etc file as PROT_EXEC.

=2E.. but I don't see why this would need to be in the initial patch set.=
=20
We need to take some time to explore the design space here (see=20
additional comments below), and I don't think it's necessary to wait for =
it.

> Maybe, in extreme pseudocode:
>=20
> fd =3D open(=E2=80=9C/dev/sgx/enclave=E2=80=9D);
> ioctl(fd, SGX_CREATE_FROM_FILE, file_fd);
> // fd now inherits the LSM label from the file, or is otherwise marked.=

> mmap(fd, PROT_READ|PROT_EXEC, ...);
>=20
> I suppose that an alternative would be to delegate all the EADD calls
> to a privileged daemon, but that=E2=80=99s nasty.
>=20

What file format should this be in? I have worked with several different =

binary enclave formats and I don't really like any of them.

# ELF

Pros:
* People know about ELF.
* Allows storing additional metadata that is only used by userspace, not =

the enclave itself.

Cons:
* ELF generally loads all kinds of stuff in memory that is not necessary =

for enclaves, such as the ELF header.
* Special tools are needed to calculate ENCLAVEHASH, for signing &=20
verification.
* All tools need to agree on the exact transformation.
* Unclear how to specify things such as: which 256-byte chunks of memory =

should be measured, heap, TCS pages, stacks, SSAs, etc.

Questions:
* If using ELF, should this be the same format that the Intel Linux SDK=20
uses (not documented, but source code is available) or something newly=20
standardized?

# PE (Windows Intel SDK format)

Andy suggested this in another email. I'm not sure why exactly?

Pros:
* Used by Windows enclaves?
* Allows storing additional metadata that is only used by userspace, not =

the enclave itself.

Cons:
* The format is not documented. I did some RE on this format a long time =

ago. See=20
https://github.com/fortanix/rust-sgx/blob/master/doc/WINTEL-SGX-ABI.md=20
and=20
https://github.com/fortanix/rust-sgx/blob/master/sgxs-tools/src/bin/isgx-=
pe2sgx.rs.
* PE is not really used on Linux.
* All same cons as ELF above.

# CPU-native (hash stream) "SGXS"

The security properties of an enclave are completely defined by the hash =

that's calculated by the processor while loading the enclave. The exact=20
hashed data is what I call the "SGX stream" format (SGXS). This is fully =

described by the Intel SDM. I've written down some notes about this at=20
https://github.com/fortanix/rust-sgx/blob/master/doc/SGXS.md. That=20
document also defines a notion of canonicality for streams. You can=20
ignore the section on "Enhanced SGXS", which is a failed experiment.

Pros:
* Computing ENCLAVEHASH is a simple SHA256 of the file.
* No complex transformations needed to load enclave.

Cons:
* No way to specify memory contents of non-measured memory.
* No space for non-enclave metadata (including SIGSTRUCT).
* Not a standard format for transporting binaries.

# CPU-native (instruction stream)

An enclave's memory contents is fully defined by the set of=20
ECREATE/EADD/EEXTEND/EINIT instructions that the OS needs to execute.=20
One could envision a format that describes exactly those instructions.=20
One difference with the SGXS format described above is that the enclave=20
memory is described as part of EADD, not EEXTEND. This allows including=20
specific values for non-measured memory.

Pros:
* No complex transformations needed to load enclave.
* Obvious place to store SIGSTRUCT.

Cons:
* Special tools are needed to calculate ENCLAVEHASH, for signing &=20
verification.
* No obvious space for non-enclave metadata.
* Not a standard format for transporting binaries.

---

We've been using the SGXS format for a couple of years, and also the=20
"Enhanced SGXS" format. I think SGXS make a lot of sense for SGX=20
software, Enhanced SGXS not so much. I've recently been pondering=20
developing a new format that is basically an archive (tar? but=20
preferably something with an index) of SGXS, SIGSTRUCT, some file=20
describing non-measured memory contents (format TBD), and additional=20
non-enclave metadata.

I'd be interested in hearing people's thoughts on file formats.

--
Jethro Beekman | Fortanix


--------------ms080603040003010206000000
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
Cx8wggUxMIIEGaADAgECAhBdZC9mIseKJlmxx1xn+g00MA0GCSqGSIb3DQEBCwUAMIGXMQsw
CQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxm
b3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBD
bGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQTAeFw0xODA5MTUwMDAw
MDBaFw0xOTA5MTUyMzU5NTlaMCQxIjAgBgkqhkiG9w0BCQEWE2pldGhyb0Bmb3J0YW5peC5j
b20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDRQDOQsroKjy2xAQCXLyqryJt4
Xwj8hcweJCzOnjILKHIoWlOQ0b9yIbFLIWBRt/9zdxlE5ZabDVHnkIyhcVgtU/BA73e78Wx2
LOObdg0wfs9U2CVRYhz2EPHFjGvkYKihItt69ye91hj1w7RKCrYC8KZGSZ/+sbkJzQdXVy32
lxmiNEt17GNRebpkJCaFnznd6C2a8tBAS2Fa/UNyFdEs4eoRoYSKswclRhbe81aVhqY2hjcd
O6puyyaYp5hkmau2UPih6OpRSOhbe6Tuebceg1yvumoVX3OZtGPS1VdQ+p0bxB0RE6gNs140
ZKUhrvAJDETuGaaQD4A2/6ksLunjAgMBAAGjggHpMIIB5TAfBgNVHSMEGDAWgBSCr2yM+MX+
lmF86B89K3FIXsSLwDAdBgNVHQ4EFgQUsFUcmGtaJBU7/52LyTYHC/M+LscwDgYDVR0PAQH/
BAQDAgWgMAwGA1UdEwEB/wQCMAAwIAYDVR0lBBkwFwYIKwYBBQUHAwQGCysGAQQBsjEBAwUC
MBEGCWCGSAGG+EIBAQQEAwIFIDBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEBATArMCkGCCsG
AQUFBwIBFh1odHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBaBgNVHR8EUzBRME+gTaBL
hklodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FDbGllbnRBdXRoZW50aWNhdGlv
bmFuZFNlY3VyZUVtYWlsQ0EuY3JsMIGLBggrBgEFBQcBAQR/MH0wVQYIKwYBBQUHMAKGSWh0
dHA6Ly9jcnQuY29tb2RvY2EuY29tL0NPTU9ET1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5k
U2VjdXJlRW1haWxDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNv
bTAeBgNVHREEFzAVgRNqZXRocm9AZm9ydGFuaXguY29tMA0GCSqGSIb3DQEBCwUAA4IBAQB6
v3tFEUSGv9+yY4wUjvcMyz3126nJrX5LkfEvrnCEpEiImECuoYvxOYNLYYynell7BQGtTaZg
shMfDvwpy2isoi3w1AWAfbn6npnSKLzu0BMRvcCPWY8VPmePPizTqXoPkLwgTJfSaWkxMP1u
rfL9S5NeRdkjwjHklX5IWuwwDu1hsKVZrxSSY2unCtvq67UHWz+z6rG1JQrP2YDfb98xun3y
eLBNe/LFBNnGISbkT5q6D+e5c0bgzoH9nH4bsw3t8aDqJTfT3BqQdWr4pF05ODzzeOmEqeYE
qGlD9hIL2AbmTZLjunAnARr6Fv7Sfqt23ptsGkmoZ9ZQNjT3TlwvMIIF5jCCA86gAwIBAgIQ
apvhODv/K2ufAdXZuKdSVjANBgkqhkiG9w0BAQwFADCBhTELMAkGA1UEBhMCR0IxGzAZBgNV
BAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09N
T0RPIENBIExpbWl0ZWQxKzApBgNVBAMTIkNPTU9ETyBSU0EgQ2VydGlmaWNhdGlvbiBBdXRo
b3JpdHkwHhcNMTMwMTEwMDAwMDAwWhcNMjgwMTA5MjM1OTU5WjCBlzELMAkGA1UEBhMCR0Ix
GzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UE
ChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQC+s55XrCh2dUAWxzgDmNPGGHYhUPMleQtMtaDRfTpYPpynMS6n9jR22YRq2tA9
NEjk6vW7rN/5sYFLIP1of3l0NKZ6fLWfF2VgJ5cijKYy/qlAckY1wgOkUMgzKlWlVJGyK+Ul
NEQ1/5ErCsHq9x9aU/x1KwTdF/LCrT03Rl/FwFrf1XTCwa2QZYL55AqLPikFlgqOtzk06kb2
qvGlnHJvijjI03BOrNpo+kZGpcHsgyO1/u1OZTaOo8wvEU17VVeP1cHWse9tGKTDyUGg2hJZ
jrqck39UIm/nKbpDSZ0JsMoIw/JtOOg0JC56VzQgBo7ictReTQE5LFLG3yQK+xS1AgMBAAGj
ggE8MIIBODAfBgNVHSMEGDAWgBS7r34CPfqm8TyEjq3uOJjs2TIy1DAdBgNVHQ4EFgQUgq9s
jPjF/pZhfOgfPStxSF7Ei8AwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAw
EQYDVR0gBAowCDAGBgRVHSAAMEwGA1UdHwRFMEMwQaA/oD2GO2h0dHA6Ly9jcmwuY29tb2Rv
Y2EuY29tL0NPTU9ET1JTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHEGCCsGAQUFBwEB
BGUwYzA7BggrBgEFBQcwAoYvaHR0cDovL2NydC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQWRk
VHJ1c3RDQS5jcnQwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTANBgkq
hkiG9w0BAQwFAAOCAgEAeFyygSg0TzzuX1bOn5dW7I+iaxf28/ZJCAbU2C81zd9A/tNx4+js
QgwRGiHjZrAYayZrrm78hOx7aEpkfNPQIHGG6Fvq3EzWf/Lvx7/hk6zSPwIal9v5IkDcZoFD
7f3iT7PdkHJY9B51csvU50rxpEg1OyOT8fk2zvvPBuM4qQNqbGWlnhMpIMwpWZT89RY0wpJO
+2V6eXEGGHsROs3njeP9DqqqAJaBa4wBeKOdGCWn1/Jp2oY6dyNmNppI4ZNMUH4Tam85S1j6
E95u4+1Nuru84OrMIzqvISE2HN/56ebTOWlcrurffade2022O/tUU1gb4jfWCcyvB8czm12F
gX/y/lRjmDbEA08QJNB2729Y+io1IYO3ztveBdvUCIYZojTq/OCR6MvnzS6X72HP0PRLRTiO
SEmIDsS5N5w/8IW1Hva5hEFy6fDAfd9yI+O+IMMAj1KcL/Zo9jzJ16HO5m60ttl1Enk8MQkz
/W3JlHaeI5iKFn4UJu1/cP2YHXYPiWf2JyBzsLBrGk1II+3yL8aorYew6CQvdVifC3HtwlSa
m9V1niiCfOBe2C12TdKGu05LWIA3ZkFcWJGaNXOZ6Ggyh/TqvXG5v7zmEVDNXFnHn9tFpMpO
UvxhcsjycBtH0dZ0WrNw6gH+HF8TIhCnH3+zzWuDN0Rk6h9KVkfKehIxggQ1MIIEMQIBATCB
rDCBlzELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UE
BxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9E
TyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yi
x4omWbHHXGf6DTQwDQYJYIZIAWUDBAIBBQCgggJZMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0B
BwEwHAYJKoZIhvcNAQkFMQ8XDTE5MDQyMzIxMTU0OFowLwYJKoZIhvcNAQkEMSIEIFWPUz0B
5OS2BNNEgKr/IXWxEJDhL/o7ozsBy+Aq+oLTMGwGCSqGSIb3DQEJDzFfMF0wCwYJYIZIAWUD
BAEqMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcN
AwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgb0GCSsGAQQBgjcQBDGBrzCBrDCBlzEL
MAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UEBxMHU2Fs
Zm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxPTA7BgNVBAMTNENPTU9ETyBSU0Eg
Q2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEF1kL2Yix4omWbHH
XGf6DTQwgb8GCyqGSIb3DQEJEAILMYGvoIGsMIGXMQswCQYDVQQGEwJHQjEbMBkGA1UECBMS
R3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8g
Q0EgTGltaXRlZDE9MDsGA1UEAxM0Q09NT0RPIFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24g
YW5kIFNlY3VyZSBFbWFpbCBDQQIQXWQvZiLHiiZZscdcZ/oNNDANBgkqhkiG9w0BAQEFAASC
AQAIkYJsyyjGImw/g7L+EbEPHDpKNHJ6qwStVxCxipDioAiosDhL2G9r8gC9Ms2PCGNMkEnE
5ogv5WR9ckzUJ+NtnStP7U8kmYLVQdXrCxTtBV9d+qB/hqJpUpfJ4k4c7oEybbReso+zfK0I
9tBq4guKfI7Oof+BV6R0sP9J52w5VDt9YnhScIYdgMNmWjE/J/XRVLPQGg7j2VQcXlPzgRaJ
POMaEEYsxuTwU1A7I75GlKysC3UMYUjDSaRqJohGj2GKeeUQciV5PlCkBW+nYE7IsEUY7XVj
pxasSvUe8vM70Q9m8nFlGUNT+sBPeXjfDPXxYMYJgrC5cbBlFjpuvp2lAAAAAAAA

--------------ms080603040003010206000000--
