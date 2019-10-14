Return-Path: <SRS0=YPfn=YH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6597FECE58D
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Oct 2019 08:43:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 196A520659
	for <linux-sgx@archiver.kernel.org>; Mon, 14 Oct 2019 08:43:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="mOu1Apqi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730439AbfJNInN (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 14 Oct 2019 04:43:13 -0400
Received: from mail-eopbgr700096.outbound.protection.outlook.com ([40.107.70.96]:30269
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730281AbfJNInN (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 14 Oct 2019 04:43:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wkc2Ry5WonJKWT6pde04tzh06zdjyJVevugORB0ZQGi3Ts8vpjQZ60ErIxwyiUj6dMrw3wtNSerB3NWtBv66Exw5a0ZYgpyY6XSozWjVhDYJ7JnNs0werzmoagNqNrufT6opzFQ7GP9bu3cXTVj/aaolvwFqpHHo3uqg8lIQHYa9pMdB8vk9WEIpaoq23lq83G6j3FW5A/tK0dPdvVzhliv4i7MRilLAvwWwQbFZE6QZqqh4mOzO7tmHnvaGbmqKiFWQ2Bgfo0reeAnV+upDO1Q/WIkwmLPn5GUTzjHkAwoqu1jJCSZPrItGGtgcWAiqpfM09JNxUEk8TQEkfd0dng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdYoYX8tEt1eGceC7e/V9vflg+SmQNxllxN4U1/J9is=;
 b=d/r1lITd8G9W/Kem/0JV3ioIlD8R8f1dceDFS9UNwbtcL4qIzrZDaUn1+PWSFNrmrdu6X5sAzkM4JBBT5vgDYE6DsmJIpjtyyZ4IIx+1pR+sOn2Zjr/DnWz6+X0ukAuppws7koCx47d+G9iORYqe26tK3m0kCtt2D0fKkpC/D4dsMz7Efp2wNnAJgD5uyeoJOxKo21bSdB76LjcM1YgiSnOZEyf3fRUSwWmIrFlYckifKgPawTATqCfHZHmuc0RquiAa8yXzoxEX05AF7j91QEodQ/nlI3FMK8eUhk392BW4V8HQyn5ZW8z1Al41mLztG5DrKLOetX4f0EcjSp0D8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdYoYX8tEt1eGceC7e/V9vflg+SmQNxllxN4U1/J9is=;
 b=mOu1ApqiXzKceKBp8eYOfTxYDR5N/Q/Qx3zZ8Qi7aTwaD6Cm7m7LhkuCsCKZ3aOC5Jft+5MW7zJFopeev6T6edOXvWkGnv4mQiJDid5SwPfuAULLf6sqUlF6woQUg07SX41gfONVYBAdng9r0Ic0Bzxp2wVGn2vJA78IYYMsEuM=
Received: from MN2PR11MB3743.namprd11.prod.outlook.com (20.178.253.14) by
 MN2PR11MB3584.namprd11.prod.outlook.com (20.178.251.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.21; Mon, 14 Oct 2019 08:43:09 +0000
Received: from MN2PR11MB3743.namprd11.prod.outlook.com
 ([fe80::1069:89da:2e89:4de9]) by MN2PR11MB3743.namprd11.prod.outlook.com
 ([fe80::1069:89da:2e89:4de9%7]) with mapi id 15.20.2347.021; Mon, 14 Oct 2019
 08:43:09 +0000
From:   Jethro Beekman <jethro@fortanix.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
CC:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>
Subject: Re: x86/sgx: v23-rc2
Thread-Topic: x86/sgx: v23-rc2
Thread-Index: AQHVf18m9ttV+e6GE0ir+CdMME1pGadVpY2AgAAbhwCABBb4gA==
Date:   Mon, 14 Oct 2019 08:43:09 +0000
Message-ID: <8dc2ab24-baf1-5e57-3906-35e7286f7ffe@fortanix.com>
References: <20191010113745.GA12842@linux.intel.com>
 <a657081e-cdaf-7c9d-2695-23c9c07bcfbf@fortanix.com>
 <20191011181550.GB30935@linux.intel.com>
In-Reply-To: <20191011181550.GB30935@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0248.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8a::20) To MN2PR11MB3743.namprd11.prod.outlook.com
 (2603:10b6:208:f4::14)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [212.61.132.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4dfc6115-0b2c-47d4-51dd-08d750828a14
x-ms-traffictypediagnostic: MN2PR11MB3584:
x-microsoft-antispam-prvs: <MN2PR11MB358438468A5AD2C8AFD6C39BAA900@MN2PR11MB3584.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01901B3451
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(366004)(39830400003)(396003)(346002)(376002)(52314003)(199004)(189003)(25786009)(486006)(66066001)(316002)(6486002)(229853002)(54906003)(14444005)(256004)(86362001)(508600001)(14454004)(8936002)(99936001)(8676002)(66446008)(64756008)(66556008)(31696002)(476003)(66946007)(66616009)(66476007)(4001150100001)(71200400001)(71190400001)(81166006)(81156014)(6246003)(52116002)(386003)(7736002)(76176011)(3846002)(53546011)(6506007)(2616005)(6116002)(99286004)(4326008)(305945005)(6916009)(2906002)(102836004)(186003)(26005)(31686004)(11346002)(6436002)(5660300002)(6512007)(36756003)(446003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR11MB3584;H:MN2PR11MB3743.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +/5YaIQXo4gAlvK8/PyDdj9Tle9ZXvvuivrMRmXRp8eF5slcSLKCowqXIpCv53NAmkbCPauGu61SPumOi7kZXgS887pdM+ljKg9+/kGe3HXOlfunUJEdpgvvq21QM1VklPZXUt3xm5fFjqEep9d9/5c8ieO9V7JFLYI0gyYUn+XaBBQZFxDBHHKAj4v59/ltk3ytnz4FrN3yYSTNuHgSinEddj5f8qdOktW8ITrka/10Tz5AOYA1ehGRNknmnp8Ng0mzFLymtXrzOd9d8zhey2G1IxNac7N4lfs0TYH4rWEkQ33T0Y7CD8Y038QmBNKa3GzCvFONVQYfzvlzGrEcgUtpj3GMW6LHwLjglZcMjlZHB74PwIUrtIbcgbLOYoBwiW8OMLt5I88DtmUEb+cn7bpaqFAYl38lMAkBwWOAsSU=
x-ms-exchange-transport-forked: True
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms090004050004090906060802"
MIME-Version: 1.0
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dfc6115-0b2c-47d4-51dd-08d750828a14
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2019 08:43:09.2060
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FTKkz4AzI9/VUgL5kxaJtLLTlLqalmt0Qe3dLU/AdYogPqZLPy1dzf3IMz3xLULhFSpKTXTKVyIuvlwSMrqm8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3584
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms090004050004090906060802
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2019-10-11 20:15, Sean Christopherson wrote:
> On Fri, Oct 11, 2019 at 04:37:25PM +0000, Jethro Beekman wrote:
>> UAPI:
>>
>> This got a whole lot more complex for userspace compared to the out-of=
-tree
>> driver.
>>
>> 1. Manually needing to mmap a naturally-aligned memory region by alloc=
ating
>> too much memory and then unmapping parts is quite annoying. Why was th=
e
>> auto-aligning removed? I think this will need to be handled the same f=
or
>> every consumer of SGX, so I don't see why this is not handled in the k=
ernel.
>> It never seems wrong to align if NULL is passed as the requested addre=
ss.
>> Alternatively, is there room in the flags for a MAP_ALIGNED bit?
>=20
> I'm pretty sure everyone agrees it's annoying.  The short of it is that=

> the SGX driver is the wrong place to do the alignment.  The driver coul=
d
> key off addr=3D0, but we don't want to take on that implicit behavior.

Why not?

> A MAP_ALIGNED flag to have the allocation be naturally aligned is the
> ideal solution.  It's definitely something we should pursue, but that c=
an
> and probably should be done in parallel to the SGX series.
>=20
>> 2. Having to re-open the device for every enclave is also annoying. Th=
is
>> means you need a filesystem available throughout the process lifetime.=
 I
>> tried dup, but that doesn't work. Can we make dup work?
>=20
> The semantics of dup() won't get you what want, as dup() just creates a=

> new descriptor pointing at the same file.
>=20
> An alternative solution that was proposed was to have an ioctl() for
> creating an enclave.  But that means using an anonymous inode, which ru=
ns
> afoul of SELinux permissions, e.g. every _process_ that runs enclaves
> would require EXECMEM.  Linus was quite clear that SGX wouldn't be merg=
ed
> if using it required users to degrade existing security.

It's ok if it's the same inode, it just needs to be a different struct fi=
le.

> I'm open to other ideas.  I wasn't aware this was a pain point and file=

> stuff isn't exactly my area of expertise, so I haven't put much/any
> thought into alternatives.

The default permissions for /dev/sgx/enclave are root-only. This means yo=
u want to be able to do the same thing as network servers: initialize som=
e resources as root, then drop privileges. This used to mean opening /dev=
/sgx and keeping the fd around which meant you could launch enclaves at w=
ill. With the new API, this is no longer possible, you can only launch on=
e enclave per fd. Is there a different type of operation that doesn't jus=
t duplicate the fd but also the struct file? If not, can we add an ioctl =
for that?

There are other scenarios where it's not just the permissions on /dev/sgx=
/enclave that are the problem but using the filesystem in general that is=
=2E Maybe you've used seccomp to disable file operations, etc.

>> 3. Needing to mprotect every page with the precise permissions needed =
after
>> EINIT is really bad. This means I have to remember this data for every=
 page
>> between EADD and EINIT. I don't care about SELinux, I trust the ECPM w=
ill do
>> its job for me. Can we make it so that I can protect the whole range a=
t once,
>> or protect the individual pages at EADD time?
>=20
> You can mprotect() or mmap(..., MAP_FIXED) an enclave range once all
> pages covered by the specified range have been added to the enclave, i.=
e.
> at EADD.  I double checked this with the selftest.  Holler if you're
> seeing different behavior.

I'd swear I tried this flow and I was getting EACCES. But I implemented i=
t again now, and it works fine. So this is not an issue.

I also saw mmap(..., MAP_FIXED) being used in the selftest. Is there a re=
ason to use this over mprotect?

>> VDSO:
>>
>> It is *difficult* to link to weakly link to a symbol in the VDSO. Anyw=
ay, I
>> figured it out.
>>
>> 1. What if I don't want to automatically ERESUME after kernel interrup=
t?
>=20
> Do EENTER/ERESUME directly instead of going through the vDSO.

That kind of defeats the point.

>> 2. I normally do a sanity check after ENCLU[EENTER] that EAX =3D EEXIT=
=2E The
>> current implementation just clears EAX instead without looking at it.
>=20
> Hmm, the only reason I can think of for checking EAX would be to suppor=
t
> userspace mucking with EAX in a #DB/#BP signal handler.  At that point,=
 I
> would expect the signal handler to modify RIP as well.  Reaching the XO=
R
> via any other non-EEXIT path would require a kernel bug.

Or a CPU bug.

> Was there a specific scenario or use case you had in mind?  I'm not
> against adding a check, I just don't see what value it would provide.

Nothing specific. It just seems like a prudent thing to do when messing w=
ith control flow in unexpected ways. Alternatively, just remove the xor, =
and change the API of the function so that 3 is the normal return value? =
Then the user can decide themselves if they think the check is worth it.

--
Jethro Beekman | Fortanix


--------------ms090004050004090906060802
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCC
C54wggVPMIIEN6ADAgECAhAFFr+cC0ZYZTtbKgQCBwyyMA0GCSqGSIb3DQEBCwUAMIGCMQsw
CQYDVQQGEwJJVDEPMA0GA1UECAwGTWlsYW5vMQ8wDQYDVQQHDAZNaWxhbm8xIzAhBgNVBAoM
GkFjdGFsaXMgUy5wLkEuLzAzMzU4NTIwOTY3MSwwKgYDVQQDDCNBY3RhbGlzIENsaWVudCBB
dXRoZW50aWNhdGlvbiBDQSBHMTAeFw0xOTA5MTYwOTQ3MDlaFw0yMDA5MTYwOTQ3MDlaMB4x
HDAaBgNVBAMME2pldGhyb0Bmb3J0YW5peC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQDHWEhcRGkEl1ZnImSqBt/OXNJ4AyDZ86CejuWI9jYpWbtf/gXBQO6iaaEKBDlj
Vffk2QxH9wcifkYsvCYfxFgD15dU9TABO7YOwvHa8NtxanWr1xomufu/P1ApI336+S7ZXfSe
qMnookNJUMHuF3Nxw2lI69LXqZLCdcVXquM4DY1lVSV+DXIwpTMtB+pMyqOWrsgmrISMZYFw
EUJOqVDvtU8KewhpuGAYXAQSDVLcAl2nZg7C2Mex8vT8stBoslPTkRXxAgMbslDNDUiKhy8d
E3I78P+stNHlFAgALgoYLBiVVLZkVBUPvgr2yUApR63yosztqp+jFhqfeHbjTRlLAgMBAAGj
ggIiMIICHjAMBgNVHRMBAf8EAjAAMB8GA1UdIwQYMBaAFH5g/Phspz09166ToXkCj7N0KTv1
MEsGCCsGAQUFBwEBBD8wPTA7BggrBgEFBQcwAoYvaHR0cDovL2NhY2VydC5hY3RhbGlzLml0
L2NlcnRzL2FjdGFsaXMtYXV0Y2xpZzEwHgYDVR0RBBcwFYETamV0aHJvQGZvcnRhbml4LmNv
bTBHBgNVHSAEQDA+MDwGBiuBHwEYATAyMDAGCCsGAQUFBwIBFiRodHRwczovL3d3dy5hY3Rh
bGlzLml0L2FyZWEtZG93bmxvYWQwHQYDVR0lBBYwFAYIKwYBBQUHAwIGCCsGAQUFBwMEMIHo
BgNVHR8EgeAwgd0wgZuggZiggZWGgZJsZGFwOi8vbGRhcDA1LmFjdGFsaXMuaXQvY24lM2RB
Y3RhbGlzJTIwQ2xpZW50JTIwQXV0aGVudGljYXRpb24lMjBDQSUyMEcxLG8lM2RBY3RhbGlz
JTIwUy5wLkEuLzAzMzU4NTIwOTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0
O2JpbmFyeTA9oDugOYY3aHR0cDovL2NybDA1LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRI
Q0wtRzEvZ2V0TGFzdENSTDAdBgNVHQ4EFgQUAXkM7yNq6pH6j+IC/7IsDPSTMnowDgYDVR0P
AQH/BAQDAgWgMA0GCSqGSIb3DQEBCwUAA4IBAQC8z+2tLUwep0OhTQBgMaybrxTHCxRZ4/en
XB0zGVrry94pItE4ro4To/t86Kfcic41ZsaX8/SFVUW2NNHjEodJu94UhYqPMDUVjO6Y14s2
jznFHyKQdXMrhIBU5lzYqyh97w6s82Z/qoMy3OuLek+8rXirwju9ATSNLsFTzt2CEoyCSRtl
yOmR7Z9wgSvD7C7XoBdGEFVdGCXwCy1t9AT7UCIHKssnguVaMGN9vWqLPVKOVTwc4g3RAQC7
J1Aoo6U5d6wCIX4MxEZhICxnUgAKHULxsWMGjBfQAo3QGXjJ4wDEu7O/5KCyUfn6lyhRYa+t
YgyFAX0ZU9Upovd+aOw0MIIGRzCCBC+gAwIBAgIILNSK07EeD4kwDQYJKoZIhvcNAQELBQAw
azELMAkGA1UEBhMCSVQxDjAMBgNVBAcMBU1pbGFuMSMwIQYDVQQKDBpBY3RhbGlzIFMucC5B
Li8wMzM1ODUyMDk2NzEnMCUGA1UEAwweQWN0YWxpcyBBdXRoZW50aWNhdGlvbiBSb290IENB
MB4XDTE1MDUxNDA3MTQxNVoXDTMwMDUxNDA3MTQxNVowgYIxCzAJBgNVBAYTAklUMQ8wDQYD
VQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwaQWN0YWxpcyBTLnAuQS4v
MDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENB
IEcxMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwPzBiVbZiOL0BGW/zQk1qygp
MP4MyvcnqxwR7oY9XeT1bES2DFczlZfeiIqNLanbkyqTxydXZ+kxoS9071qWsZ6zS+pxSqXL
s+RTvndEaWx5hdHZcKNWGzhy5FiO4GZvGlFInFEiaY+dOEpjjWvSeXpvcDpnYw6M9AXuHo4J
hjC3P/OK//5QFXnztTa4iU66RpLteOTgCtiRCwZNKx8EFeqqfTpYvfEb4H91E7n+Y61jm0d2
E8fJ2wGTaSSwjc8nTI2ApXujoczukb2kHqwaGP3q5UuedWcnRZc65XUhK/Z6K32KvrQuNP32
F/5MxkvEDnJpUnnt9iMExvEzn31zDQIDAQABo4IB1TCCAdEwQQYIKwYBBQUHAQEENTAzMDEG
CCsGAQUFBzABhiVodHRwOi8vb2NzcDA1LmFjdGFsaXMuaXQvVkEvQVVUSC1ST09UMB0GA1Ud
DgQWBBR+YPz4bKc9Pdeuk6F5Ao+zdCk79TAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaA
FFLYiDrIn3hm7YnzezhwlMkCAjbQMEUGA1UdIAQ+MDwwOgYEVR0gADAyMDAGCCsGAQUFBwIB
FiRodHRwczovL3d3dy5hY3RhbGlzLml0L2FyZWEtZG93bmxvYWQwgeMGA1UdHwSB2zCB2DCB
lqCBk6CBkIaBjWxkYXA6Ly9sZGFwMDUuYWN0YWxpcy5pdC9jbiUzZEFjdGFsaXMlMjBBdXRo
ZW50aWNhdGlvbiUyMFJvb3QlMjBDQSxvJTNkQWN0YWxpcyUyMFMucC5BLiUyZjAzMzU4NTIw
OTY3LGMlM2RJVD9jZXJ0aWZpY2F0ZVJldm9jYXRpb25MaXN0O2JpbmFyeTA9oDugOYY3aHR0
cDovL2NybDA1LmFjdGFsaXMuaXQvUmVwb3NpdG9yeS9BVVRILVJPT1QvZ2V0TGFzdENSTDAO
BgNVHQ8BAf8EBAMCAQYwDQYJKoZIhvcNAQELBQADggIBAE2TztUkvkEbShZYc19lifLZej5Y
jLzLxA/lWxZnssFLpDPySfzMmndz3F06S51ltwDe+blTwcpdzUl3M2alKH3bOr855ku9Rr6u
edya+HGQUT0OhqDo2K2CAE9nBcfANxifjfT8XzCoC3ctf9ux3og1WuE8WTcLZKgCMuNRBmJt
e9C4Ug0w3iXqPzq8KuRRobNKqddPjk3EiK+QA+EFCCka1xOLh/7cPGTJMNta1/0u5oLiXaOA
HeALt/nqeZ2kZ+lizK8oTv4in5avIf3ela3oL6vrwpTca7TZxTX90e805dZQN4qRVPdPbrBl
WtNozH7SdLeLrcoN8l2EXO6190GAJYdynTc2E6EyrLVGcDKUX91VmCSRrqEppZ7W05TbWRLi
6+wPjAzmTq2XSmKfajq7juTKgkkw7FFJByixa0NdSZosdQb3VkLqG8EOYOamZLqH+v7ua0+u
lg7FOviFbeZ7YR9eRO81O8FC1uLgutlyGD2+GLjgQnsvneDsbNAWfkory+qqAxvVzX5PSaQp
2pJ52AaIH1MN1i2/geRSP83TRMrFkwuIMzDhXxKFQvpspNc19vcTryzjtwP4xq0WNS4YWPS4
U+9mW+U0Cgnsgx9fMiJNbLflf5qSb53j3AGHnjK/qJzPa39wFTXLXB648F3w1Qf9R7eZeTRJ
fCQY/fJUMYID9jCCA/ICAQEwgZcwgYIxCzAJBgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8x
DzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwaQWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5Njcx
LDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZY
ZTtbKgQCBwyyMA0GCWCGSAFlAwQCAQUAoIICLzAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcB
MBwGCSqGSIb3DQEJBTEPFw0xOTEwMTQwODQzMDVaMC8GCSqGSIb3DQEJBDEiBCAjKxt466wy
B5ENWR+WUhh/njN6mlrZogxYmRzLeoLyCjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAgoiL6Ti3BXaLbOSmeR7N2Sd8KspTQ0dhTEpE4IGiHFzXG+HUq9dzCKdK
ouNyZx6uRAkyXPw3fjjaq4vaLfdP+fJ6pupYT4Xk38XWES359jLnyYYWGZVVkcF2avOi2QrU
kxnX656/pAsQyyj87E3IwE7SCiJ3ljbLQ1PRexGWl4N2IQ+kZ/TYKGoMxEIaZ8L5+W82OrOZ
MRMfdml+TViK19wHNg2p4L4KX/lOAxyQnC1ricM6b1EVj6rr5E/twVPToYI+YoRz96I2qApa
w0UNUaX0REJyvFalHhEBZkbkKVp4eKnkh0qFeC9JhHgjawqqe8dcwzuDx9MKy05a/UAFVAAA
AAAAAA==

--------------ms090004050004090906060802--
