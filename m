Return-Path: <SRS0=LqHz=B6=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E236C433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Aug 2020 17:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51DE820885
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Aug 2020 17:53:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="rE1rvMYR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgHTRxs (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Aug 2020 13:53:48 -0400
Received: from mail-co1nam11on2098.outbound.protection.outlook.com ([40.107.220.98]:36193
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725834AbgHTRxm (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Aug 2020 13:53:42 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TDLicuYopSVdKyxyZ2uhe+9o9WxjgKcnoPgteF9aPHbKX7JxlYxmcCUvVZTZ34ZgRg8ZSOAUA8C6WMjwp44MZ3gGm8YXfvB3dHMUvYQTEddmAsp9wRHONb2xLmo9oSUqauKRGV3h/XX8o2q625lYGkjau0TNWBqjJyv6ECjEtybr1+4kvySPSq/Bdp+i9jJ53xdvHg/G36uvjzcpqZY3oNCm61CzLTNMTZFyEjmmjqFCUPMQj/Y2gCAo9kfj3VHPj70zdnZcCjN8UCoZU8dmOaFBNBIk8Q4Gel6sTJ6CPCCxhGGOLVz7RIwEKR/BfsjMTZDMPYCrOfix8DPLdthhlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHd3WsiA3UIl0j3DB1h1Ko2x4GC6wxvIAVY+1cvbrNc=;
 b=kCR1aD/Ius0oH9iCEDyfBM1QGuZYZcsXQxOF6P8GAmyXcyZ9MCmljWixyZYHW2ui7pW7tkSTCBvPXmk8Oo4omz5yT0lZnaG0a1ahS8uBnExKNuGKf8jKNXpA14pL2A03y3EUpmH2qwGnCJ9qvB5UmNyUcmUJX90rp4wnDgLcLEiUx4SFs3K6fE6KtxYDa/7OAZOT5PpzhYjTI2vrGgALPYlYt/KZF9sZl5WaNbp5VDRDlG9WO60h4OItroLylzckBOUC2fwCWdGAks5lJRPVYF514zQoNdRDTdIcXGgZocRHZEahPiPW71QNxrm0cFt4605J2Rr93nZPUUaXHfVa8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHd3WsiA3UIl0j3DB1h1Ko2x4GC6wxvIAVY+1cvbrNc=;
 b=rE1rvMYRgiLCIU3bBucVHjbvXZK9/RyUrhmQ8axyDR3hQuwy2tx2pfqXm4/mu/qS5x/yoof/uvCDW3XT7K6cCNBYASBQ0yHcj+f5ft/lwxrOa7R8CNf1iaug1L+rWyHsvFZPxc8exfk+/jpVL5Kww/f0JXqAUXNzGxN/2gk4zrg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BYAPR11MB3190.namprd11.prod.outlook.com (2603:10b6:a03:7b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.22; Thu, 20 Aug
 2020 17:53:39 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::11b2:63eb:a7db:80c5%6]) with mapi id 15.20.3283.028; Thu, 20 Aug 2020
 17:53:39 +0000
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
 <8603e74e-6484-6e28-164f-2b0f908d5986@fortanix.com>
 <CALCETrVTxdssjtp1+E8RH5wek2FauJTmJhGqp8taBzXVSm6VFQ@mail.gmail.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <9d3e6c56-c491-3449-9d29-ee566e994d4e@fortanix.com>
Date:   Thu, 20 Aug 2020 19:53:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <CALCETrVTxdssjtp1+E8RH5wek2FauJTmJhGqp8taBzXVSm6VFQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms050308050508040000020009"
X-ClientProxiedBy: LO3P265CA0012.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:bb::17) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.195.0.246] (212.61.132.179) by LO3P265CA0012.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:bb::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Thu, 20 Aug 2020 17:53:37 +0000
X-Originating-IP: [212.61.132.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be10c8cb-3c1c-4aa1-ef7a-08d84531f7e3
X-MS-TrafficTypeDiagnostic: BYAPR11MB3190:
X-Microsoft-Antispam-PRVS: <BYAPR11MB31903D975BFCFF3D8DEEAAF5AA5A0@BYAPR11MB3190.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ywAyX3SszCHTz0CJxN6X7fkSkbxzpg8LZp8IVQmRatXoTGihocRTCptTuweo2KN7u6FBUAmMkFYyNhpbLlM0wYaMAlL3hBTAxp0adYBjIpojyV9JlCPuwZGKbF1YPheLjxQdlammC3ZA6s8jI7394RQAQ31DFCMU0GEU3DgWE4bzo/g3BcKMBAxHWaTT3sMH+6iqhK0QK0DlPitHdCix5mNVjTa/3VW35J9wHtGmx17JSyCCOoDdEyl2EslewopCrjthC9lO/WeBWXDm31AJFnzhThp+oyLqJY/N4sLnUzk1knnzRnmTfyffdiDGCfyQtvOk7m5vlyORut9qJh1ePF/TabHHhwYf8QXdfRZxht2zHLWY4VFhP0a8PNLrHC2M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(346002)(39840400004)(136003)(6916009)(8936002)(83380400001)(31686004)(478600001)(54906003)(16576012)(8676002)(86362001)(316002)(4326008)(26005)(31696002)(2616005)(956004)(66476007)(2906002)(36756003)(16526019)(6666004)(5660300002)(33964004)(66946007)(52116002)(53546011)(186003)(235185007)(6486002)(66556008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: DeJZgFw0BsmvIaCB2C5U341JPo/W/j4zS5Va86Bnh+8ULsUqHLPZ2K3D/TKnGKrgOsLH+PHAN+MnrH5/ZoQ1oHaa9C0ONsSsAt2uB9joSOxAM0gx1OI2CP7cmXOXA1X5kCSasMhgwb6BmwPyWojJsIS2UdgQIWuUPsKXo4K6WEMqpr7Nt+V9E7OrP6NQWS2tzggiX85FUQAf6e6Q7A7Te0YfWprV0HIzhJ2gmF3uMjpoalfCUfk3s7rGEL2BVVCM2/a9nmHKfFWqbUC8EDiKtaAlT7dgaGS2jfWgxFF9S0Dq7pKBdcqvuFSZqJCOOwdjhh4xdCEebW/AAj/BtLbpE5V02p4HBoGJSmFNVHU81ut3+vvipX1v9FceGJkf2FamgvohZ55yS/5I1xNcxIpLXvM6aqUrYV69bFnH7/4aqzwcBmtkgagm3laRAWYv0FwFmo2AzH+lH120/biavRJ+szn5Rm4RhugeU8s/pl6NcDZvPRF5mfISH5jE8ofH1Yc0DHIPtQaBtuJ06vYLjGKowM5NoVXVgnXBdW7M7OSJkk39UOAWsGxBQlHRr7IFrogA58+ycEe5IkdOTYs+hPS4yfO5ovm/VWgaFeOG55GjCWSXyWubsJQ4YqCydzjlAkrQrzrK+Sq0tnJhtRU0QTOExQ==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be10c8cb-3c1c-4aa1-ef7a-08d84531f7e3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR11MB4260.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2020 17:53:39.2456
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bYK8Ctb5+CWPfAku32RLmhr8LTNOp7V7p6l1Aceyy3NpN7EX+2GDbn3ytQiE7iKF3V3dEPa39aZdZdKNHUEfOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3190
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms050308050508040000020009
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-08-20 19:44, Andy Lutomirski wrote:
> On Thu, Aug 20, 2020 at 4:20 AM Jethro Beekman <jethro@fortanix.com> wr=
ote:
>>
>> On 2020-08-19 17:02, Andy Lutomirski wrote:
>>> On Wed, Aug 19, 2020 at 7:21 AM Jethro Beekman <jethro@fortanix.com> =
wrote:
>>>>
>>>> On 2020-08-18 19:15, Andy Lutomirski wrote:
>>>>> On Mon, Aug 17, 2020 at 9:24 PM Sean Christopherson
>>>>> <sean.j.christopherson@intel.com> wrote:
>>>>>>
>>>>>> Allow userspace to exit the vDSO on interrupts that are acknowledg=
ed
>>>>>> while the enclave is active.  This allows the user's runtime to sw=
itch
>>>>>> contexts at opportune times without additional overhead, e.g. when=
 using
>>>>>> an M:N threading model (where M user threads run N TCSs, with N > =
M).
>>>>>
>>>>> This is IMO rather odd.  We don't support this type of notification=
 on
>>>>> interrupts for normal user code.  The fact user code can detect
>>>>> interrupts during enclave execution is IMO an oddity of SGX, and I
>>>>> have asked Intel to consider replacing the AEX mechanism with
>>>>> something more transparent to user mode.  If this ever happens, thi=
s
>>>>> mechanism is toast.
>>>>
>>>> Let's design the current interface for the current architecture. We =
can deal with a new architecture if and when Intel provides it.
>>>
>>> No.  If Intel fixes the architecture, the proposed interface will
>>> *stop working*.
>>>
>>>>
>>>>> Even without architecture changes, building a *reliable* M:N thread=
ing
>>>>> mechanism on top of this will be difficult or impossible, as there =
is
>>>>> no particular guarantee that a thread will get timing interrupts at=
> all or that these interrupts will get lucky and hit enclave code, thus
>>>>> triggering an AEX.  We certainly don't, and probably never will,
>>>>> support any corresponding feature for non-enclave code.
>>>>
>>>> There's no guarantee, but this vDSO exit mechanism is a prerequisite=
=2E Both for context switching and aborting an enclave, userspace *must* =
have a way to trigger exit from enclave mode *and* recover the user stack=
 in a sane manner. Userspace *should* also be able to do this in a way th=
at's compatible with library use, so calling timer_create or pthread_kill=
 to deliver a signal would be ok, but installing a signal handler should =
be avoided (the whole reason behind this vDSO call).
>>>
>>> If you want to abort an enclave, abort it the same way you abort any
>>> other user code -- send a signal or something.  If something is wrong=
> with signal handling in the proposed vDSO interface, then by all
>>> means, let's fix it.  If we need better library signal support, let's=

>>> add such a thing.  If you really want to abort an enclave *cleanly*
>>> without any chance of garbage left around, stick it in a subprocess.
>>> We are not playing the game where someone sets a flag, crosses their
>>> fingers, and waits for an interrupt.
>>
>> Sending a signal is not sufficient. The current __vdso_sgx_enter_encla=
ve call is not interruptible.
>>
>=20
> Why not?  If we are failing to deliver signals if
> __vdso_sgx_enter_enclave() is running, we have a bug and we should fix
> it.  We should actually deliver the signal and then either resume the
> enclave or return -EINTR or equivalent.  Are we getting this wrong?
> Looking at your code, I think we're doing it right but maybe we could
> do better.
>=20
> I suppose we also need a test case for this if we do anything fancy her=
e.
>=20
>>> Now maybe I'm wrong and there's an actual legitimate use case for thi=
s
>>> trick, in which case I'd like to be enlightened.  But M:N threading
>>> and enclave aborting don't sound like legitimate use cases.
>>>
>>
>> Why is it ok for this code to return to userspace after 1 second:
>>
>>
>>
>> void ignore_signal_but_dont_restart(int s) {}
>>
>> // set SIGALRM handler if none set (FIXME: racy)
>> struct sigaction sa_old;
>> struct sigaction sa =3D {
>>     .sa_handler =3D ignore_signal_but_dont_restart,
>>     .sa_flags =3D 0,
>> };
>> sigaction(SIGALRM, &sa, &sa_old);
>> if (!(sa_old.sa_handler =3D=3D SIG_IGN || sa_old.sa_handler =3D=3D SIG=
_DFL)
>>     || (sa_old.sa_flags & SA_SIGINFO)) {
>>     sa_old.sa_flags &=3D ~SA_RESTART;
>>     sigaction(SIGALRM, &sa_old, NULL);
>> }
>>
>> alarm(1);
>>
>> char buf;
>> read(0, &buf, 1);
>>
>=20
> Seems fine.  That's POSIX.  User code is receiving a signal and is
> being affected by the signal.  A signal is a user-visible thing.
>=20
>>
>>
>> But, according to your train of thought, this code must hang indefinit=
ely (assuming the enclave is not calling EEXIT)?
>>
>>
>>
>> void ignore_signal_but_dont_restart(int s) {}
>>
>> // set SIGALRM handler if none set (FIXME: racy)
>> struct sigaction sa_old;
>> struct sigaction sa =3D {
>>     .sa_handler =3D ignore_signal_but_dont_restart,
>>     .sa_flags =3D 0,
>> };
>> sigaction(SIGALRM, &sa, &sa_old);
>> if (!(sa_old.sa_handler =3D=3D SIG_IGN || sa_old.sa_handler =3D=3D SIG=
_DFL)
>>     || (sa_old.sa_flags & SA_SIGINFO)) {
>>     sa_old.sa_flags &=3D ~SA_RESTART;
>>     sigaction(SIGALRM, &sa_old, NULL);
>> }
>>
>> alarm(1);
>>
>> __vdso_sgx_enter_enclave(0, 0, 0, 2, 0, 0, tcs, NULL, NULL);
>>
>=20
> This is a genuine semantic question: is __vdso_sgx_enter_enclave()
> like read on a pipe (returns -EINTR on a signal) or is it more like a
> restartable syscall or a normal library function that just keeps
> running if your signal handler does nothing?  You could siglongjmp()
> out, but that's a bit gross.
>=20
> I wouldn't object to an option to __vdso_sgx_enter_enclave() to make
> it return -EINTR if signaled by a non-SA_RESTART signal.  Implementing
> it might be distinctly nontrivial, though.
>=20
> But this isn't what this patch does, and I suspect we've been talking
> past each other.  This patch makes __vdso_sgx_enter_enclave() return
> if there's an *interrupt*.  If you push a keyboard button, move your
> mouse, get a network interrupt on that core, etc, it will return.
> This is nonsense.

It's not nontrivial to return on signals, this patch does it. This patch =
*also* returns when there's a HW interrupt, but that's not important.=20

It sounds like you're saying you want to subdivide AEXs into =E2=80=9Cint=
errupts that lead to user-observable signals=E2=80=9D and =E2=80=9Cother =
interrupts=E2=80=9D, and then hide the second category from the user. I w=
ouldn't object to that, but I don't know how to code this. It seems like =
a lot of work compared to the obvious solution (this patch).

--
Jethro Beekman | Fortanix


--------------ms050308050508040000020009
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA4MjAxNzUzMzJaMC8GCSqGSIb3DQEJBDEiBCD70qe1giHf
kAFjEAHTlqsWIYTqq68CWkpr+1j1pE+bPTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAE743wAvoa+nsqin1nBuX/j8BTUf8Ra7+Try7pJ+6OnEkVi0KYxSEPD6S
sSlq4EjHYZwVakyfLrVdbsPdwfz29QhQa/Hz+MVJY22yK9Q7vP/DJKJ46gJ1d5OrvrcqTuyT
uDKEAGYITPwY+DzPGgLDX2PJ5sj84Beg7S2EiU2vpbREZGjDTHCeQw0Q2RglchUdI/DPsuQB
53guU7bVqMtacGn0He1CsqvGJi+VVS1e7zwJOlUIoOpfRu9KizoEgUtZYsLQUlmYC1K86ueK
Z/FHaV5q+SHDf7rVQNxVZODxxW9MkGki5j6Nmf4D6jdNei6bMxmn6x6Jcta0YxmWF/xGfQAA
AAAAAA==

--------------ms050308050508040000020009--
