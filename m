Return-Path: <SRS0=LqHz=B6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F25D8C433E3
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Aug 2020 11:20:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C63802078D
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Aug 2020 11:20:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="GsRDLsVN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgHTLU4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Aug 2020 07:20:56 -0400
Received: from mail-dm6nam10on2120.outbound.protection.outlook.com ([40.107.93.120]:6145
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730448AbgHTLUV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Aug 2020 07:20:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HM4SmfbtPYKRu3GuvxaATeb+Jz37Rf4CKe+g51YBGLIPQp6/PMh0EARs7Qq53AlnfI3onkdJbYgbgtoAESb+ji8bJbA28K+W8NO+/Y5mECVrEiZezryNhWeU0FsVv6AMde9XGZIM7vZxGqC2XaJlmHc8n5sSgp0PN7H0qUgCHnbR/vzqWvQFIi5r4S4Q5MUveF39PsxqWu9B81mRxTZ9+XE5rB5VZSm3mTFootF4Vxs+ATzW+toA6GX8EK+587N17dnEFUIiav7vz/dJCmGThZxI3ewUN8iMFjSRmuiRYOlxQlaXZnnx/CV9FJ0tJXRtm2xy96YlDIuFQAAg0arj0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L1HXEVOWYeixPXBXEfxPUf7HinOB0VZMEBNAN/VWkFo=;
 b=UXhgsZ7t/57lQ9C/7DuswKP5rvfALDS06ZXCuFaFi3Ib4Dc6zKP0ECy5NQTpo2ad+DvjC+rvNnc64HOMR3Cs0tn2/M2ypjb3CpBtpBemF7FmTx3+NZlb0w70F9k0SQWWBy5ZTRV7S9Y6oY4vA+GZcw4aR0ROH8BGwCHWkJkK4ki1INfpaJqJh5gv3v/zexq4D6YGbhgEoJIYUlDYvLivYip/spOf02gmlgNC/vKQqw0EqF/izFNF2OPlSXbvGkyWVKS5UCxLcJEAkiuEU3yFNHPMti5xZp+GSNQkE+72JZclLnH6YpspARen72unp/3/ErwoP/ADbO40KT0yUXNRag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L1HXEVOWYeixPXBXEfxPUf7HinOB0VZMEBNAN/VWkFo=;
 b=GsRDLsVNusKmMQ9Rl/DI8DOmaWQ1Yygow39GrNT0OuB1RH8spIEstxcBJNLiylv9pZ31lWBt0kPF6OzuFi+565TzyNrqlTBMewSptRJd5EpieuCQ8N/ADGJczUaq6PcGEkhs1QnFopKFuL99AlZeScTQ9bBDmDbecqwvy29xr9k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB4259.namprd11.prod.outlook.com (2603:10b6:a03:1be::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 20 Aug
 2020 11:20:15 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3283.028; Thu, 20 Aug 2020
 11:20:15 +0000
Subject: Re: [RFC PATCH 4/4] x86/vdso: x86/sgx: Allow the user to exit the
 vDSO loop on interrupts
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>, linux-sgx@vger.kernel.org
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-5-sean.j.christopherson@intel.com>
 <CALCETrVRAdzFcJOJN6oU1F7hC57zYSmFZi6y2DwhU0sd27FJjQ@mail.gmail.com>
 <6109f3e1-0579-67c6-0a02-f9b931ba1fac@fortanix.com>
 <CALCETrW94nC5jtQcn7tCMm4itrGSbpxSadtyQUJ=UcR4bFPJ4Q@mail.gmail.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <8603e74e-6484-6e28-164f-2b0f908d5986@fortanix.com>
Date:   Thu, 20 Aug 2020 13:20:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALCETrW94nC5jtQcn7tCMm4itrGSbpxSadtyQUJ=UcR4bFPJ4Q@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms090701010702020705000305"
X-ClientProxiedBy: LO2P265CA0409.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a0::13) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.195.0.246] (212.61.132.179) by LO2P265CA0409.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a0::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.24 via Frontend Transport; Thu, 20 Aug 2020 11:20:14 +0000
X-Originating-IP: [212.61.132.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a11b5c18-b31b-4311-ff81-08d844fb0352
X-MS-TrafficTypeDiagnostic: BY5PR11MB4259:
X-Microsoft-Antispam-PRVS: <BY5PR11MB425995223F9975640BCF1607AA5A0@BY5PR11MB4259.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UCATfo5H6PLB0qXLhhsEgrwp8xb3zRPrLWF1pfoY/oMF5nLS2S58LHA2QpqpNMNgBmmV9AujpNq+rMOCHZiPvKWstKJTQCn5xQwkmQihGcraAZhCQ+LDVbII5Zvhw9YFDsylB1Kqu9o3i0LGOYw745GRjmdEJEvFSSYRM0K10P/h9dNw1JezisuccNxeNBXHtg6i2UPS5iBoeeZDcKr4zlMDiOatn6/+7ihcSRRgr/X86HWgRId5+VD5OzNwFIGqPS/MVUlB8DRR96k9B8cJ6FoaX1XF0OXAY20/0cnZ+h1iR2qQhtR5BRmSX+x+erlzMsHBOLRiX3Hfr9qJJRZHdbHQMpCoLo9tAfXJktG9N5XPem5+j0g40BtlyfwjlufD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39840400004)(366004)(396003)(136003)(376002)(346002)(4326008)(6666004)(83380400001)(8676002)(26005)(16526019)(186003)(2906002)(36756003)(54906003)(6486002)(16576012)(86362001)(316002)(478600001)(33964004)(6916009)(8936002)(5660300002)(31696002)(235185007)(66946007)(53546011)(66476007)(66556008)(2616005)(956004)(52116002)(31686004)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: nU2WDduoTDu6D64uEZda8NeVC4V7vNCC6RMpWjie5QRTKepz+Zp3DerqQzcIqul+8rhhatBPfMZdMrpz4x2IuQMHOixz0YZ7yObxj/nLoR4rRfU42ft6DWb/Ttws5UUJbWGt/nhpg532b7UanPNDEZ2Vt8TQQW3MK3xqSUCK3uADBnxOWN3zDjCVC0cq6BAr/6E4atk8oPSG0zRnoc3/EOACOhcvqYF8Fppc9D+qA55ATwraGlBVyMjbMHKgEtKBnaVACfzU12i/n9P1a/HZ2h7XwJ8UQeIONabNWiHGvZhwe3jvdiT1HUQbf3xeErIhtC1n1epBzoFGietWX7/0f/Prlbjn5i8j0/tAz1pNeEtih9lYAlGOTTNM/vj2MH/9ZwG/Hi5GPMdW9eE/TQdTqh0FoJssgTBoc9WUOGrJRXehCPWtbbJ9bKwc6UnSw6unv6usrLKabsN+gRhoTprGey+nP3IUi9pr62+2ezsKmcD6BTUrakE2wlfOk52LxuWBpYBb0dZMFUNPxIlmiDyTAKNl0gv8wBOsB9vpyvktDPhHKo1Tpk+H3nkZcUCebJhm9zzalJcb7aFFHBtOIyRNevkL/WMSsvmo5F/gUfLy2YCKKhn5Zmh/yoWpFPdA3afq4gVz2AkGRD3UH3N7kPpYxg==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a11b5c18-b31b-4311-ff81-08d844fb0352
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 11:20:15.7845
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 27Lduxrr/TBiGKWAtODgPUuRZSi4mi+0wIxuG1M8OMB7kpNWQAI3v36d71bKARlIVmpq1S+XyRjVG/AuA6Bvrw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4259
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms090701010702020705000305
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-08-19 17:02, Andy Lutomirski wrote:
> On Wed, Aug 19, 2020 at 7:21 AM Jethro Beekman <jethro@fortanix.com> wr=
ote:
>>
>> On 2020-08-18 19:15, Andy Lutomirski wrote:
>>> On Mon, Aug 17, 2020 at 9:24 PM Sean Christopherson
>>> <sean.j.christopherson@intel.com> wrote:
>>>>
>>>> Allow userspace to exit the vDSO on interrupts that are acknowledged=

>>>> while the enclave is active.  This allows the user's runtime to swit=
ch
>>>> contexts at opportune times without additional overhead, e.g. when u=
sing
>>>> an M:N threading model (where M user threads run N TCSs, with N > M)=
=2E
>>>
>>> This is IMO rather odd.  We don't support this type of notification o=
n
>>> interrupts for normal user code.  The fact user code can detect
>>> interrupts during enclave execution is IMO an oddity of SGX, and I
>>> have asked Intel to consider replacing the AEX mechanism with
>>> something more transparent to user mode.  If this ever happens, this
>>> mechanism is toast.
>>
>> Let's design the current interface for the current architecture. We ca=
n deal with a new architecture if and when Intel provides it.
>=20
> No.  If Intel fixes the architecture, the proposed interface will
> *stop working*.
>=20
>>
>>> Even without architecture changes, building a *reliable* M:N threadin=
g
>>> mechanism on top of this will be difficult or impossible, as there is=

>>> no particular guarantee that a thread will get timing interrupts at> =
all or that these interrupts will get lucky and hit enclave code, thus
>>> triggering an AEX.  We certainly don't, and probably never will,
>>> support any corresponding feature for non-enclave code.
>>
>> There's no guarantee, but this vDSO exit mechanism is a prerequisite. =
Both for context switching and aborting an enclave, userspace *must* have=
 a way to trigger exit from enclave mode *and* recover the user stack in =
a sane manner. Userspace *should* also be able to do this in a way that's=
 compatible with library use, so calling timer_create or pthread_kill to =
deliver a signal would be ok, but installing a signal handler should be a=
voided (the whole reason behind this vDSO call).
>=20
> If you want to abort an enclave, abort it the same way you abort any
> other user code -- send a signal or something.  If something is wrong> =
with signal handling in the proposed vDSO interface, then by all
> means, let's fix it.  If we need better library signal support, let's
> add such a thing.  If you really want to abort an enclave *cleanly*
> without any chance of garbage left around, stick it in a subprocess.
> We are not playing the game where someone sets a flag, crosses their
> fingers, and waits for an interrupt.

Sending a signal is not sufficient. The current __vdso_sgx_enter_enclave =
call is not interruptible.

>=20
>>
>>> So this seems like an odd, and possibly unsupportable, feature to add=
=2E
>>
>> I can implement all this without the vDSO call today, so why not suppo=
rt it? That just means not everyone is going to use the vDSO call, again =
resulting in potential problems when multiple libraries want to use encla=
ves.
>=20
> No offense, but if you want to write garbage software with entirely
> user code, I can't stop you, but the kernel is not going to give this
> anything resembling a stamp of approval.  When you inevitably discover
> that it has broken for one reason or another and your software stack
> stops making forward progress, I don't want anyone playing the "ABI
> stability" card and asking the upstream kernel to work around the
> breakage.
>=20
> Now maybe I'm wrong and there's an actual legitimate use case for this
> trick, in which case I'd like to be enlightened.  But M:N threading
> and enclave aborting don't sound like legitimate use cases.
>=20

Why is it ok for this code to return to userspace after 1 second:



void ignore_signal_but_dont_restart(int s) {}

// set SIGALRM handler if none set (FIXME: racy)
struct sigaction sa_old;
struct sigaction sa =3D {
    .sa_handler =3D ignore_signal_but_dont_restart,
    .sa_flags =3D 0,
};
sigaction(SIGALRM, &sa, &sa_old);
if (!(sa_old.sa_handler =3D=3D SIG_IGN || sa_old.sa_handler =3D=3D SIG_DF=
L)
    || (sa_old.sa_flags & SA_SIGINFO)) {
    sa_old.sa_flags &=3D ~SA_RESTART;
    sigaction(SIGALRM, &sa_old, NULL);
}

alarm(1);

char buf;
read(0, &buf, 1);



But, according to your train of thought, this code must hang indefinitely=
 (assuming the enclave is not calling EEXIT)?



void ignore_signal_but_dont_restart(int s) {}

// set SIGALRM handler if none set (FIXME: racy)
struct sigaction sa_old;
struct sigaction sa =3D {
    .sa_handler =3D ignore_signal_but_dont_restart,
    .sa_flags =3D 0,
};
sigaction(SIGALRM, &sa, &sa_old);
if (!(sa_old.sa_handler =3D=3D SIG_IGN || sa_old.sa_handler =3D=3D SIG_DF=
L)
    || (sa_old.sa_flags & SA_SIGINFO)) {
    sa_old.sa_flags &=3D ~SA_RESTART;
    sigaction(SIGALRM, &sa_old, NULL);
}

alarm(1);

__vdso_sgx_enter_enclave(0, 0, 0, 2, 0, 0, tcs, NULL, NULL);



Tested on Linux 5.9-rc1 with SGX patches v36.

--
Jethro Beekman | Fortanix


--------------ms090701010702020705000305
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA4MjAxMTIwMDlaMC8GCSqGSIb3DQEJBDEiBCBXIeBkmvka
Mkdu8HSCDCb13DLk776JYbGER6i9v3rdkDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAOu1PkXjyZzPY6gakbqijls+aAh3wA5K/xFK7wXjObA30arHVKbWp+qeN
fG70WzJSlpyh2jUHBDyTSryxNQVdwC1I4pUW4LCUfm+VOVevmy/u6G8ZPmlhYUuJ8dHNN+8u
e/rF2AX6V1a7JWiSaIoPYS7AH6RTYrWiSNf9HpOGeu+/oky0+of6nekOW4eXmBumPSWtbr1Q
eeiaOTf/MQq31vI9pqJnu9CEGBj1WUfr82zHUwsu/99sv0z+dD6wmf3MjQHtU3BjdbGI+TEw
hVoRuOwtPr3fV65B30bt0qrNSaI5uB32LHIyf7n+N354kHHxaritbH1ZOpbIR8n3FP9k+wAA
AAAAAA==

--------------ms090701010702020705000305--
