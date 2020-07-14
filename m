Return-Path: <SRS0=Ypn8=AZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00EADC433E1
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Jul 2020 10:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF0B1217D8
	for <linux-sgx@archiver.kernel.org>; Tue, 14 Jul 2020 10:08:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="ANnIZpi5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgGNKIJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 14 Jul 2020 06:08:09 -0400
Received: from mail-co1nam11on2127.outbound.protection.outlook.com ([40.107.220.127]:14496
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725906AbgGNKIJ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 14 Jul 2020 06:08:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ip/5KcVDcU9BbKEh4Z+ymfh+IwoNFge6E8Ml3Nfvc6IGrjJqo6sJyYAuVDqBiH2SjS0B7Lfe+mwoLP4vWP40Zdyg1S0Um5X5ogXfl7F/4WIVVLorjpybEahHHH5J0R45Udo4mx4aEmCGBzpZy/e/5YhSmVxuKja6fEALC4FRT032MQ9+FAkiD56lOlWzIAXJQhyoJFEdXVF8mM5m2VlHHYlPfY2MpVzTmXNvt3KvO83/BNtgAwD2pjeX2N6lrIR8F2dw82v/qOlDjTnJrfSrG7vUDm8mu+oBXf8uNkPF9UnfQyNIhACYf53ctVphFjGjWIAbxui7VKdTDM6BjQIs+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8BenOslwqTNtD+K7y0Qkuxv/y0yp/F3tYJWUGl6S04g=;
 b=FioIqSqUHvvo1o/2uB2P4M82945cb4d4Je9zJ7GPb26H6JexfLEwEJU7g/0Jk/jZnpe7MSdPQ97R9zjoMJLR6dJHlOGRv+PCAio+K8kYFkSIUKluUPE2M3HpSqfKlhSJKNVM5eVMQbhwA3NzqDclfhx6L5L/RiAuB9SzhbaOEhdjW6ovC3TI7cH8uEyn2PkHYjbs9V9zRxndEXRvwfBZnAoBrIl5CV7n26Ng90kcjjZaefh0tGy31NFZNH8aeIAeI/9+36YpkyQKcd3UcmRTP4H01+suSZwDgSCjD21Pi70xzj8jvlEHOLnIwHia1yFNTKaAunwhFaV38t1/5ZnwMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8BenOslwqTNtD+K7y0Qkuxv/y0yp/F3tYJWUGl6S04g=;
 b=ANnIZpi56FITHRd63SP7s84cNEh3zFnrA4BNy+F00zpym60BlhVurFyFC/piD/13RgYg+Wxvs+j9bffzRkXd8G3MMJIRaFyyMvxJeqnC0Xg6jQyax7ApwgpTIQ8J1CA6ZFC7P/1FbBdM9rpMQ8rADaQzxqndXl3wUQrkaMMw3vM=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fortanix.com;
Received: from CH2PR11MB4262.namprd11.prod.outlook.com (10.141.127.205) by
 CH2PR11MB4280.namprd11.prod.outlook.com (10.141.127.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.23; Tue, 14 Jul 2020 10:08:04 +0000
Received: from CH2PR11MB4262.namprd11.prod.outlook.com
 ([fe80::6079:7e19:b08a:4295]) by CH2PR11MB4262.namprd11.prod.outlook.com
 ([fe80::6079:7e19:b08a:4295%5]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 10:08:04 +0000
Subject: Re: [PATCH v35 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Cedric Xing <cedric.xing@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, tglx@linutronix.de, yaozhangx@google.com
References: <20200707033747.142828-1-jarkko.sakkinen@linux.intel.com>
 <20200707033747.142828-22-jarkko.sakkinen@linux.intel.com>
 <dcebec2e-ea46-48ec-e49b-292b10282373@fortanix.com>
 <20200714095649.GC1442951@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <dedb73fd-f543-e0e3-dff8-b4150c22bd94@fortanix.com>
Date:   Tue, 14 Jul 2020 12:07:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200714095649.GC1442951@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms080600000307080900030002"
X-ClientProxiedBy: AM0PR06CA0112.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::17) To CH2PR11MB4262.namprd11.prod.outlook.com
 (2603:10b6:610:42::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.127.58) by AM0PR06CA0112.eurprd06.prod.outlook.com (2603:10a6:208:ab::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Tue, 14 Jul 2020 10:07:59 +0000
X-Originating-IP: [213.127.127.58]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 647f5f30-702a-4501-95ea-08d827ddcbd6
X-MS-TrafficTypeDiagnostic: CH2PR11MB4280:
X-Microsoft-Antispam-PRVS: <CH2PR11MB428092E208D02A5B375292E9AA610@CH2PR11MB4280.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uXo759rFie4vYr9qKSLZkpq4WwlnQ9dFgXSrNRPjSpxRXx4Mp32F+smOzPWOPeqC5k8EGgzm1Ptfy1PLot2boLcXuxUWOiG8/b8mjDJfY8kdwshxH0fhMTVIm/I41bkF3CdV3nJkO2siUbgmNgXUjCysgjJwgyKVXOzk1qJRP/fcINwI4jdHoBcCgUd/PZIAbKZwV9Xh4ebRE+D0SorGicHLZt8weWR4+yw0ORpMaSX+iyc6x7UOrSV2JfLF1/P6Z1/uFwDD2c2ARqMlRh1+pu/NKUZg8h6S8dz9QQn2qci+WLbpU5uPiSuHmtaerV68dRxmR0wwf89izec2ZdsCP/Pp2QOUg5Wr3C6EsVu5+LbE0O5edIKG41OLYnCSE/JpY0S4LekT4uRKmwfPaMPm9cJHZ2z+v2mO42fvNPFO1bOxpR+tC7oM5oMDijEWxFJVIKdMcMrq4PcmPFS1oTrL0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR11MB4262.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(346002)(376002)(366004)(39840400004)(136003)(54906003)(2906002)(31696002)(235185007)(5660300002)(16576012)(6666004)(83380400001)(8676002)(6916009)(8936002)(66946007)(7416002)(33964004)(316002)(66556008)(508600001)(36756003)(956004)(2616005)(52116002)(86362001)(4326008)(53546011)(31686004)(966005)(16526019)(6486002)(186003)(66476007)(26005)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: RyV6KB6RA/dKQKJG6a18NpWkW5Nw5Hp39cw7Qxpya/AEM4rRPkngR8HAbpF0zqkt1Pp08Xl7mg65OJuFtrjPTYL8Fxr6WCVv7xRGmSxsxyyFXxVvVfz7xs23Q0ZN3sfE7yY0kItZptUzX9u7cFyAGoOTyu72+GcH18tZaAWDLS23PwazJ8H0APob8ghkKCEig+o5+31Aqxo/oXBhygDNjFo1OSHT+zA1qD9O3ZTCZrAoVbcp/2TbBHHhXtzjG8TMo2TY1Gj1whPTcGk0numoh39NX7uu7Slmb/t0QXSIGwqpA4dvjxH94WfplLaa5EbMmocaSSWRsr1oeVWGEPkeWMRQqgyqjcCHVLU5xQHvZwSjRzQZyfnuysKeg2v8khqB/T5XsYfk3AH30m1JJn1e9vu1PFcsIPD1I3dHTkE3smPkhlIIW1TZa+1NbBWvTOhRcHChameVPPokxml9GOsrvkgcF7JKobEMwXX7SR6xVV8=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 647f5f30-702a-4501-95ea-08d827ddcbd6
X-MS-Exchange-CrossTenant-AuthSource: CH2PR11MB4262.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 10:08:03.9045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tpbyu48nhkh03X0DdKp4w2mJnrO1hB3+awq5ajUOYI78++HOphoB8RVzXutyKGYjmkXHspbj53qJqoldYWdV4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4280
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms080600000307080900030002
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-07-14 11:56, Jarkko Sakkinen wrote:
> On Tue, Jul 14, 2020 at 09:30:03AM +0200, Jethro Beekman wrote:
>> On 2020-07-07 05:37, Jarkko Sakkinen wrote:
>>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>>
>>> An SGX runtime must be aware of the exceptions, which happen inside a=
n
>>> enclave. Introduce a vDSO call that wraps EENTER/ERESUME cycle and re=
turns
>>> the CPU exception back to the caller exactly when it happens.
>>>
>>> Kernel fixups the exception information to RDI, RSI and RDX. The SGX =
call
>>> vDSO handler fills this information to the user provided buffer or
>>> alternatively trigger user provided callback at the time of the excep=
tion.
>>>
>>> The calling convention is custom and does not follow System V x86-64 =
ABI.
>>>
>>> Suggested-by: Andy Lutomirski <luto@amacapital.net>
>>> Acked-by: Jethro Beekman <jethro@fortanix.com>
>>> Tested-by: Jethro Beekman <jethro@fortanix.com>
>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> Co-developed-by: Cedric Xing <cedric.xing@intel.com>
>>> Signed-off-by: Cedric Xing <cedric.xing@intel.com>
>>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>>> ---
>>>  arch/x86/entry/vdso/Makefile             |   2 +
>>>  arch/x86/entry/vdso/vdso.lds.S           |   1 +
>>>  arch/x86/entry/vdso/vsgx_enter_enclave.S | 131 +++++++++++++++++++++=
++
>>>  arch/x86/include/asm/enclu.h             |   8 ++
>>>  arch/x86/include/uapi/asm/sgx.h          |  98 +++++++++++++++++
>>>  5 files changed, 240 insertions(+)
>>>  create mode 100644 arch/x86/entry/vdso/vsgx_enter_enclave.S
>>>  create mode 100644 arch/x86/include/asm/enclu.h
>>>
>>> diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makef=
ile
>>> index ebe82b7aecda..f71ad5ebd0c4 100644
>>> --- a/arch/x86/entry/vdso/Makefile
>>> +++ b/arch/x86/entry/vdso/Makefile
>>> @@ -29,6 +29,7 @@ VDSO32-$(CONFIG_IA32_EMULATION)	:=3D y
>>>  vobjs-y :=3D vdso-note.o vclock_gettime.o vgetcpu.o
>>>  vobjs32-y :=3D vdso32/note.o vdso32/system_call.o vdso32/sigreturn.o=

>>>  vobjs32-y +=3D vdso32/vclock_gettime.o
>>> +vobjs-$(VDSO64-y)		+=3D vsgx_enter_enclave.o
>>> =20
>>>  # files to link into kernel
>>>  obj-y				+=3D vma.o extable.o
>>> @@ -100,6 +101,7 @@ $(vobjs): KBUILD_CFLAGS :=3D $(filter-out $(GCC_P=
LUGINS_CFLAGS) $(RETPOLINE_CFLAGS
>>>  CFLAGS_REMOVE_vclock_gettime.o =3D -pg
>>>  CFLAGS_REMOVE_vdso32/vclock_gettime.o =3D -pg
>>>  CFLAGS_REMOVE_vgetcpu.o =3D -pg
>>> +CFLAGS_REMOVE_vsgx_enter_enclave.o =3D -pg
>>> =20
>>>  #
>>>  # X32 processes use x32 vDSO to access 64bit kernel data.
>>> diff --git a/arch/x86/entry/vdso/vdso.lds.S b/arch/x86/entry/vdso/vds=
o.lds.S
>>> index 36b644e16272..4bf48462fca7 100644
>>> --- a/arch/x86/entry/vdso/vdso.lds.S
>>> +++ b/arch/x86/entry/vdso/vdso.lds.S
>>> @@ -27,6 +27,7 @@ VERSION {
>>>  		__vdso_time;
>>>  		clock_getres;
>>>  		__vdso_clock_getres;
>>> +		__vdso_sgx_enter_enclave;
>>>  	local: *;
>>>  	};
>>>  }
>>> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entr=
y/vdso/vsgx_enter_enclave.S
>>> new file mode 100644
>>> index 000000000000..be7e467e1efb
>>> --- /dev/null
>>> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
>>> @@ -0,0 +1,131 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> +
>>> +#include <linux/linkage.h>
>>> +#include <asm/export.h>
>>> +#include <asm/errno.h>
>>> +#include <asm/enclu.h>
>>> +
>>> +#include "extable.h"
>>> +
>>> +#define EX_LEAF		0*8
>>> +#define EX_TRAPNR	0*8+4
>>> +#define EX_ERROR_CODE	0*8+6
>>> +#define EX_ADDRESS	1*8
>>> +
>>> +.code64
>>> +.section .text, "ax"
>>> +
>>> +SYM_FUNC_START(__vdso_sgx_enter_enclave)
>>> +	/* Prolog */
>>> +	.cfi_startproc
>>> +	push	%rbp
>>> +	.cfi_adjust_cfa_offset	8
>>> +	.cfi_rel_offset		%rbp, 0
>>> +	mov	%rsp, %rbp
>>> +	.cfi_def_cfa_register	%rbp
>>> +	push	%rbx
>>> +	.cfi_rel_offset		%rbx, -8
>>> +
>>> +	mov	%ecx, %eax
>>> +.Lenter_enclave:
>>> +	/* EENTER <=3D leaf <=3D ERESUME */
>>> +	cmp	$EENTER, %eax
>>> +	jb	.Linvalid_leaf
>>> +	cmp	$ERESUME, %eax
>>> +	ja	.Linvalid_leaf
>>> +
>>> +	/* Load TCS and AEP */
>>> +	mov	0x10(%rbp), %rbx
>>> +	lea	.Lasync_exit_pointer(%rip), %rcx
>>> +
>>> +	/* Single ENCLU serving as both EENTER and AEP (ERESUME) */
>>> +.Lasync_exit_pointer:
>>> +.Lenclu_eenter_eresume:
>>> +	enclu
>>
>> After thinking about this some more, I'd like to come back to this
>> setup. Prior discussion at https://lkml.org/lkml/2018/11/2/597 . I
>> hope I'm not derailing the discussion so much as to delay the patch
>> set :(
>>
>> I previously mentioned =E2=80=9CUserspace may want fine-grained contro=
l over
>> enclave scheduling=E2=80=9D as a reason userspace may want to specify =
a
>> different AEP, but gave a bad example. Here's a better example: If I'm=

>> running my enclave in an M:N threading model (where M user threads run=

>> N TCSs, with N > M), an AEX is a good oppurtunity to switch contexts.
>> Yes, I could implement this with alarm() or so, but that adds overhead=

>> while missing out on a lot of opportunities for context switching.
>=20
> The vDSO interface also provides optional callback. Wonder if that
> works for this or can it be refined to work for this?

Yeah I think if the callback was called instead of ENCLU, the callback ha=
s the opportunity to return non-positive which will trigger a return from=
 __vdso_sgx_enter_enclave. Moving .Lasync_exit_pointer to .Lhandle_exit m=
ight be sufficient. But I imagine not all users would want this behavior =
(although calling the few userspace instructions is likely negligible com=
pared to the actual ERESUME).

--
Jethro Beekman | Fortanix


--------------ms080600000307080900030002
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA3MTQxMDA3NTRaMC8GCSqGSIb3DQEJBDEiBCC12W27xxXK
uwFsEt7NfE0nLqQUBah26up0b61PDD9+QzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAuLE7RJ8RVKdbumQgIW3DUdg2JFq38OwzrBceYrW/v3Dq/ai14LKxVcJs
j04X9l09dtc40Gq2hwCO+sKshkpnumKuAJmzdD74kOFG1WsVQ0BqKiTZYXndbPnDMToCExBq
MRbagdlM3eu0T+VkdTD2R0gZlXGeR0O3zfAKiilCGGLnb0jktsfZf/pZfqDv1SuG6p/ZLEAn
ExqZ2sOBB2XhBWtV58JhshH5QV8X1rcwFtPrhWDok53TdclYSt5tcDwGynEfx7F2dYTkIiv+
uqlWaoEy54u+Kb40npCdEaJewbsUeDmNrXYRL4kRXIgCmB6lIoYE2/gtJGjxgzl4rdoB8QAA
AAAAAA==

--------------ms080600000307080900030002--
