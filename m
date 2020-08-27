Return-Path: <SRS0=BSu2=CF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,RCVD_ILLEGAL_IP,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D697CC433E1
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Aug 2020 08:57:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A383022B47
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Aug 2020 08:57:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="pTpx3Eo0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgH0I5U (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Aug 2020 04:57:20 -0400
Received: from mail-eopbgr700098.outbound.protection.outlook.com ([40.107.70.98]:1760
        "EHLO NAM04-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726882AbgH0I5T (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 27 Aug 2020 04:57:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AxJwuG4FKPkhivrL9wHPDvUS+icj6FDYBFxgQglrLIPMPA90O9cbIwRysOJ5ld5424WGrW+BuLHxBNqyAPTg47tVaco/gN3CNqyzzgFATmD5Swypf6OprkmpxgKp1Xt3NiyxwpfGOOJny4f/YCjUtE41rnQKJcKgA45rxD8FUGS0JaFaYbq0pt4XtU+/fmcgPksq/eg1SJYNcasy24s4BtX1CJAoTbq26TRaY/7c6I1WxNgkXlqqSz8OCVvAM8HlIfWLSSlsMlupCOPaiuUlSBc6l7OB96RIWpuA60FckmXwUb/5PfejMzmnc/r0qVhHUiphrNqfvaTOhNW4GagSuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pz8pmupy30dCzRLR+Lw2S8/IFYxHHtzulgu+9A6n4y8=;
 b=l/fiPQuuRpfwDJ5aUCehWQRDSe5nTZ7ytfFYk71EosjGougDMPQS+Ah7ySSB/ZBcTV2s3jsMJxKJrnF+4+fiOtiYLM3vlQ7DJkWZqBw91YpGnupXJHp8cm2txHtamc841fNvMRW0FcVE8aLBGSiRsV/i6X8+YoJ2ysiGOF15Nqn9O/5a9uR1Vl7covHuuk+V0w8gbztSr+LxJwLNxWSd8VGAusauluaWdv6NZTZhZvQA8Xhbo5Nes/MOpyLLRiS3e+nWHfH76/DuIuMqhrLS+03+9Wa/ak+GP9I57YudLvSTZgCUVBLkT5Z9QSylrm2eTm6Xh4XxDh0Sq1rH1ghPWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pz8pmupy30dCzRLR+Lw2S8/IFYxHHtzulgu+9A6n4y8=;
 b=pTpx3Eo0S+UfTJr+OttZMg0BeUK1mtIOFrZCmJOdmSYeFg8/mEtFnIUiZYs5yoZNeS2Qr0unTUTwLJoeire2XCMD1txK32HFFtNWaHTLaAPromvU1xtG+MLUlTIeZACaLx7qBBlRjAtWCd3ocHuclk47uRwbo+GSQN3xQYpzNNs=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BYAPR11MB3559.namprd11.prod.outlook.com (2603:10b6:a03:f7::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.26; Thu, 27 Aug
 2020 08:57:13 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3305.032; Thu, 27 Aug 2020
 08:57:13 +0000
Subject: Re: [RFC PATCH 4/4] x86/vdso: x86/sgx: Allow the user to exit the
 vDSO loop on interrupts
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>, linux-sgx@vger.kernel.org
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-5-sean.j.christopherson@intel.com>
 <CALCETrVRAdzFcJOJN6oU1F7hC57zYSmFZi6y2DwhU0sd27FJjQ@mail.gmail.com>
 <6109f3e1-0579-67c6-0a02-f9b931ba1fac@fortanix.com>
 <CALCETrW94nC5jtQcn7tCMm4itrGSbpxSadtyQUJ=UcR4bFPJ4Q@mail.gmail.com>
 <8603e74e-6484-6e28-164f-2b0f908d5986@fortanix.com>
 <CALCETrVTxdssjtp1+E8RH5wek2FauJTmJhGqp8taBzXVSm6VFQ@mail.gmail.com>
 <9d3e6c56-c491-3449-9d29-ee566e994d4e@fortanix.com>
 <CALCETrWAKLSGS-UuZcegnPSOLSh-7D9AjB82fZ7+or5hvVzj_w@mail.gmail.com>
 <46938c15-24e7-ee80-0cdc-0b35c5a19697@fortanix.com>
 <20200826183220.GB21065@sjchrist-ice>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <0f88f6d7-fa2d-59b0-c90f-4aa9e04d0af5@fortanix.com>
Date:   Thu, 27 Aug 2020 10:57:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200826183220.GB21065@sjchrist-ice>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms010802050206050305060705"
X-ClientProxiedBy: AM4PR07CA0002.eurprd07.prod.outlook.com
 (2603:10a6:205:1::15) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by AM4PR07CA0002.eurprd07.prod.outlook.com (2603:10a6:205:1::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.5 via Frontend Transport; Thu, 27 Aug 2020 08:57:11 +0000
X-Originating-IP: [213.127.112.210]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 84f4431b-c501-4356-f9c1-08d84a6730bc
X-MS-TrafficTypeDiagnostic: BYAPR11MB3559:
X-Microsoft-Antispam-PRVS: <BYAPR11MB35593AF0E01F77F34B3E1875AA550@BYAPR11MB3559.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4iBJ70Rj+WdgbtrYKT2MGi0QLNpnb/qwHnPndCmHXCrPacy+u/46HwPub1HaVdYBej4I5XPRbQNikmhguFSHx8LSdILJTGlub4ShVQr8e1nDKz6uX8z/pUOJHC6Zz6ApECI/Cj09G/J5cDMSSBD0oXAS9pmFI3u97eAb+KRmEftANNmDGPY4H45gNCxCh30E0KRTpyvVF/M2XtXECgIOjQXnE5fFR5pHz1gdEEyUCUiCjEHHn1NqbF49Qsb6PkHkNA1fhSVvznVP9p/l78kDB0dmMkk4So2TFHwvWOrZy/J1StpGQbHAIMzrUc8jdhjQj9qiUIFBMrJU3TgqXXqdKszTUJ7iFCAKtgKMdPBY3rKmzk4neNuZUghKhsoeE81G
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(396003)(39840400004)(366004)(8676002)(6916009)(5660300002)(52116002)(83380400001)(33964004)(53546011)(66946007)(6486002)(4326008)(66556008)(26005)(66476007)(478600001)(186003)(16576012)(54906003)(8936002)(2906002)(6666004)(86362001)(316002)(31696002)(2616005)(956004)(31686004)(36756003)(235185007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 7VEAVknY/7782y8sZ3SysMgCwx4JEHkZYYtcvao7V9hcBEPmtiesbukymjZaLZKwjBoTnZAwhzOALs9o0+4KZHgXl85ZyqQ6LQRCMpiX9D/Kxz/NEpT6uyj2HA8hfiy8Tm/HQETqi9h4Shzky0JfYhfOxsUgr9G5erU0k+uH401LzypzgBx2K2wS8xwUDA3alfKEUMzHGWQHKpog9wq3uIgVKbC/Fsy1N4aegFFV7IOOS7szN6UnNhg/16DNKgnEIwKf3C1YtttgzBC9VIMR5kkbR9x9SZyDt5vhagGykT8glDwOC1l9vT5cubaXHyHqeT9VSCVLggiw/ymSg9cOYJPXa89WtWGhxEsqm4v77EQQiMf064OtgqpEWXu9aCZA719x6viG28n9WCN7Sh7+6JIP7pMC9sx7ZyPFm9mxB3a83zpxkKEiRk+JQksgqfrErFccIQU3RdkMfnflnwnkjEuIo6p1pGhUeheB/3R6jPwjXY8ckiGKJqhbO2U2gNqU3bEZx/Ob392+GV3MJVoRtAdIMA46Y9DPLdf5Te3O+WGnvBSlC1thtAKPR2IUWdweGY6g+6RKNYNX0ZM5/tl1y2L3asy55oI09pLkd1ET+s+ygY+0amyFHxzaZm3iWIHRe3mK9YZ75sHgQpK0BvHV+w==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84f4431b-c501-4356-f9c1-08d84a6730bc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2020 08:57:13.4642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wABG/0B1sjV+9M/+K6qpXL1vRMq7ZZJZmFfhmX15nzBSnxpFVrdCEDVSsmZMioM3gI13z2w+c4vyDvA3dIDYag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3559
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms010802050206050305060705
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-08-26 20:32, Sean Christopherson wrote:
> On Mon, Aug 24, 2020 at 03:36:29PM +0200, Jethro Beekman wrote:
>> On 2020-08-22 23:55, Andy Lutomirski wrote:
>>> On Thu, Aug 20, 2020 at 10:53 AM Jethro Beekman <jethro@fortanix.com>=
 wrote:
>>>>
>>>> On 2020-08-20 19:44, Andy Lutomirski wrote:
>>>>> This is a genuine semantic question: is __vdso_sgx_enter_enclave()
>>>>> like read on a pipe (returns -EINTR on a signal) or is it more like=
 a
>>>>> restartable syscall or a normal library function that just keeps
>>>>> running if your signal handler does nothing?  You could siglongjmp(=
)
>>>>> out, but that's a bit gross.
>>>>>
>>>>> I wouldn't object to an option to __vdso_sgx_enter_enclave() to mak=
e
>>>>> it return -EINTR if signaled by a non-SA_RESTART signal.  Implement=
ing
>>>>> it might be distinctly nontrivial, though.
>>>>>
>>>>> But this isn't what this patch does, and I suspect we've been talki=
ng
>>>>> past each other.  This patch makes __vdso_sgx_enter_enclave() retur=
n
>>>>> if there's an *interrupt*.  If you push a keyboard button, move you=
r
>>>>> mouse, get a network interrupt on that core, etc, it will return.
>>>>> This is nonsense.
>>>>
>>>> It's not nontrivial to return on signals, this patch does it. This p=
atch *also* returns when there's a HW interrupt, but that's not important=
=2E
>>>
>>> Allow me to quote the changelog of the patch:
>>>
>>> This allows the user's runtime to switch
>>> contexts at opportune times without additional overhead, e.g. when us=
ing
>>> an M:N threading model (where M user threads run N TCSs, with N > M).=

>>>
>>> NAK.
>>>
>>>>
>>>> It sounds like you're saying you want to subdivide AEXs into =E2=80=9C=
interrupts
>>>> that lead to user-observable signals=E2=80=9D and =E2=80=9Cother int=
errupts=E2=80=9D, and then
>>>> hide the second category from the user. I wouldn't object to that, b=
ut I
>>>> don't know how to code this. It seems like a lot of work compared to=
 the
>>>> obvious solution (this patch).
>>>
>>> The obvious solution is NAKked.
>>>
>>> Does siglongjmp() really not work for you?
>>
>> Allow me to quote the changelog of "[PATCH v36 18/24] x86/vdso: Add su=
pport
>> for exception fixup in vDSO functions":
>>
>> Putting everything together, userspace enclaves will utilize a library=

>> that must be prepared to handle any and (almost) all exceptions any ti=
me
>> at least one thread may be executing in an enclave.  Leveraging signal=
s
>> to handle the enclave exceptions is unpleasant, to put it mildly, e.g.=

>> the SGX library must constantly (un)register its signal handler based
>> on whether or not at least one thread is executing in an enclave, and
>> filter and forward exceptions that aren't related to its enclaves.  Th=
is
>> becomes particularly nasty when using multiple levels of libraries tha=
t
>> register signal handlers, e.g. running an enclave via cgo inside of th=
e
>> Go runtime.
>>
>>
>> If I could use signal handlers I wouldn't use the VDSO call. (Corollar=
y: if I
>> wasn't using the VDSO call, I wouldn't have to think about this becaus=
e what
>> I want is already supported).
>=20
> Jethro, I think what you're requesting is simply not possible.  Or rath=
er,
> the SGX vDSO can't provide any additional value relative to what can be=

> provided by userspace.
>=20
> What Andy is saying is that having the vDSO take action on interrupts i=
s
> undesirable/NAK'd from a kernel perspective, as it's ugly and unreliabl=
e.
> It happens to mostly work for SIGALRM because there is an interrupt
> associated with the expiration of the timer[*].  But even then it will
> work if and only if the interrupt arrives while the enclave is running.=

> If the interrupt arrives just before ENCLU, either on initial entry or
> on resume from the callback, SIGALRM will be delivered and the userspac=
e
> M:N scheduler that is relying on an exit from the enclave will miss its=

> "tick".
>=20
> The vDSO could check for pending signals, but that effectively provides=
 no
> value as opposed to checking for signals in the callback (or caller).
>=20
> The goal of the SGX vDSO is to obviate the need for handling signals th=
at
> are due to exceptions that are directly associated with the enclave.  I=
MO,
> the SIGALRM request is completely out of scope as it is not a problem t=
hat
> is unique to SGX, i.e. wanting to do M:N scheduling in a library withou=
t
> hooking SIGALRM is a generic request.  The fact that the SGX architctur=
e has
> a quirk that allows for a semi-functional hack is not justification for=

> supporting such a hack in the kernel.
>=20
> [*] Is it even guaranteed that an interrupt will precede SIGALRM?  Not =
that
>     it matters for this discussion.
>=20

Let's make sure the VDSO call has a flags parameter and we can talk about=
 this after merge.

--
Jethro Beekman | Fortanix


--------------ms010802050206050305060705
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA4MjcwODU3MDVaMC8GCSqGSIb3DQEJBDEiBCBBv398rVHv
IEHQ8iLPI3cxDMGMciGU1sxW9RYLstAWUzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAa9Rz4FQBGiYnJLxzDLLK8eJaAgDDs6RgF2xd/m9D9mQZIwbqE82dQ95f
ih0hsGUduptxXB7HdTs01TBbPbA5KSqF4Ql6i4LcriozVFhE/NapDIaBzwv0H7s/fWHkUuV+
YJxjZpgXKGq5lhqtyWEseuqYgyx8pTLsudWeYkzlnduNxuo6qhLepx4CpSI7oad4qDa2FLPq
8LtaMTe1p4Y4RZQ2eLkGrh50nFzkQ71q7VBD0i4uRahJJpDd1iDozrugRumdqRsmEdzF/rwN
+rDMuSQIvPdqqqYQlLbVmrJCBhozuCWRadBayynoq/geuDuN6V+Bo0OsZzhaoh6AKZtdeQAA
AAAAAA==

--------------ms010802050206050305060705--
