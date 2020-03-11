Return-Path: <SRS0=LjX6=44=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11F43C0044D
	for <linux-sgx@archiver.kernel.org>; Wed, 11 Mar 2020 17:38:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7113620738
	for <linux-sgx@archiver.kernel.org>; Wed, 11 Mar 2020 17:38:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="bdUn3vDr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbgCKRiQ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 Mar 2020 13:38:16 -0400
Received: from mail-eopbgr750112.outbound.protection.outlook.com ([40.107.75.112]:26179
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729852AbgCKRiQ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 11 Mar 2020 13:38:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0p5g00nIJNYwVJwmZ7ZwP2PrnrZD7qb8mKg+yzixhffwhf3q+K+BZ7p+rJuxxr3aMYVByRskDWuQrnSE+NhxuSBdpZn3LkACOOhkXIqRnbokfRpOwq/kikA8i6AxW39ibT2iLJfUv1vR2J3NYA32PnKiyWlWIJq8iJgVQLRlPhOMl4daac4wm9B9Z2YaqSO/cTSAwmKUyFJTI3viz3/uAXfP0o3sAhUXGTpUFEenjuOQQIrNjTaK/HTbHLfeUHCZ9SVV1UNqQye6s/qpBStjC/cLx8/qoS3GHhlca/6r9ZFjtQOjWyDd5Zf6aWsOJ91rp0qa8oi0HtHHpjWKlRJEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Syhz0+NYwtPCyH8mSTxLc+lfEufBUnQ2DXhG3kLd6BQ=;
 b=gWnLoQgOK9kS4VmYpdV9fRyHQnt+TbqcB7V888d2w7V66SQZUiI9VV5pkog2IveLXpg8vNKnlKZALtCBLDflzt7l2YDrHnYkh35rpTcaQA638vsgKRwOcLOHekxXqNdjT2ml7sYMflFNnaVTtamjQS81rm5IO79Z6LPo2lIncM5uvCRQsYXbZkEQMTUh2gNMvbhJDRRS2vy6IKFKZ41U5KPrCRsO3mi3cGLa9F7TgwKTz5uyRF4lWaE8WCWFJWjFliYLQUzFydDoej40G0CTBCnCqfS2xxYf23jT/nVX3txyFYvtNYgndlNg8jqMz1cKEE1DEAmEZvIPa9VrSF3r0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Syhz0+NYwtPCyH8mSTxLc+lfEufBUnQ2DXhG3kLd6BQ=;
 b=bdUn3vDrbylfyRM/jpEVNF5htViZGH77ZADSiQe1RvzXfGFF9imskfSwls8X8DLcd6HH7bejP8B/IyLuMvakUHD0EEfSJAkpiwCTEjMEtIHzOmTB6dcsZyScPeIhxmGFP4LuT+diwEpV4y+LUd4pvFrAlv4A+Ou0NjeN+/Hi3vs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (2603:10b6:a03:fe::29)
 by BYAPR11MB3270.namprd11.prod.outlook.com (2603:10b6:a03:7e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11; Wed, 11 Mar
 2020 17:38:10 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::dc9c:f877:efd1:401a]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::dc9c:f877:efd1:401a%4]) with mapi id 15.20.2793.013; Wed, 11 Mar 2020
 17:38:10 +0000
Subject: Re: [PATCH v28 21/22] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
To:     Nathaniel McCallum <npmccallum@redhat.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Neil Horman <nhorman@redhat.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        "Svahn, Kai" <kai.svahn@intel.com>, bp@alien8.de,
        Josh Triplett <josh@joshtriplett.org>, luto@kernel.org,
        kai.huang@intel.com, David Rientjes <rientjes@google.com>,
        cedric.xing@intel.com, Patrick Uiterwijk <puiterwijk@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Connor Kuehl <ckuehl@redhat.com>,
        Harald Hoyer <harald@redhat.com>,
        Lily Sturmann <lsturman@redhat.com>
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <254f1e35-4302-e55f-c00d-0f91d9503498@fortanix.com>
Date:   Wed, 11 Mar 2020 18:38:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <CAOASepPi4byhQ21hngsSx8tosCC-xa=y6r4j=pWo2MZGeyhi4Q@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms070905040308020906090903"
X-ClientProxiedBy: LO2P265CA0381.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::33) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.195.0.226] (212.61.132.179) by LO2P265CA0381.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a3::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Wed, 11 Mar 2020 17:38:05 +0000
X-Originating-IP: [212.61.132.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e99f8b4-9af8-4a2c-89ae-08d7c5e2f710
X-MS-TrafficTypeDiagnostic: BYAPR11MB3270:
X-Microsoft-Antispam-PRVS: <BYAPR11MB3270C862EF16432B37B569FAAAFC0@BYAPR11MB3270.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0339F89554
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(39840400004)(136003)(346002)(376002)(366004)(199004)(6486002)(31686004)(8936002)(81156014)(81166006)(956004)(52116002)(53546011)(2616005)(7416002)(36756003)(54906003)(110136005)(33964004)(2906002)(6666004)(508600001)(86362001)(316002)(8676002)(4326008)(66476007)(66556008)(26005)(66946007)(16526019)(235185007)(186003)(31696002)(16576012)(5660300002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR11MB3270;H:BYAPR11MB3734.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CzmWpNPwNauPIxwpiki7WQgfORjtPKu49mpj9W8VqD3LB2puCy2baDmgfPRsMWkPpR94KS/7yX/ro74k1ANKtnTXrhcDRx4lfgcS378/D7buhhxsZxbZq7YD4RWxd56dWLQtXSmReVmKqZEJShcXxN1J+q2o8yhMNbAupseBH9VmNqBhJpV/+Snd2h8pFoUJn+eOakSdiJC78ewNgAwuWrtVtaE3cWtFZwSV9A3LQYCdLEV3Uj3ypd0UlQwSzyBUFjum0Pbg3FMAdRgpnyjO53Nyrl/u84+rIu3jP/Si2FDyqm3a5lWVNDWH5IrlJbNbfxt8SADfjVhTaaMY3J/jIFxXl5Z6/RBb0WncsjIoxjqxbuCdDnE/3XizY3FMYGKzfxHrL/O6U6ZC39JqOAMF896dRTQ7IGtNQ3QzrqeXeG6yAhlt9HapKoLO5CNejyqJ
X-MS-Exchange-AntiSpam-MessageData: iIM0z6kgt+0kSt7u0DvtOBW6JDnGuPGefNM9eseFAXQBRdUjWDMv8ENCaTakIqlksZ1uKN3h8tZ4Ojpkz4sn0cfHCQ/LeKW1vXQQaQA73n1EzTJMidPW4iVsDZvfde2q+wP8yjQ2kZ4/XGaN7Jzg7w==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e99f8b4-9af8-4a2c-89ae-08d7c5e2f710
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Mar 2020 17:38:09.8439
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ah7aH2qcIRBCDgfMfhmmJMv2Eb6MO0UFfAuUUagjsLvbwHNZS8Lu6qa+m3RQZ8lKLVZQiAF5Xz2lm3Gtg1HaYg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3270
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms070905040308020906090903
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 2020-03-11 18:30, Nathaniel McCallum wrote:
> On Tue, Mar 3, 2020 at 6:40 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
>>
>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>
>> An SGX runtime must be aware of the exceptions, which happen inside an=

>> enclave. Introduce a vDSO call that wraps EENTER/ERESUME cycle and ret=
urns
>> the CPU exception back to the caller exactly when it happens.
>>
>> Kernel fixups the exception information to RDI, RSI and RDX. The SGX c=
all
>> vDSO handler fills this information to the user provided buffer or
>> alternatively trigger user provided callback at the time of the except=
ion.
>>
>> The calling convention is custom and does not follow System V x86-64 A=
BI.
>>
>> Suggested-by: Andy Lutomirski <luto@amacapital.net>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Co-developed-by: Cedric Xing <cedric.xing@intel.com>
>> Signed-off-by: Cedric Xing <cedric.xing@intel.com>
>> Tested-by: Jethro Beekman <jethro@fortanix.com>
>> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>> ---
>>  arch/x86/entry/vdso/Makefile             |   2 +
>>  arch/x86/entry/vdso/vdso.lds.S           |   1 +
>>  arch/x86/entry/vdso/vsgx_enter_enclave.S | 187 ++++++++++++++++++++++=
+
>>  arch/x86/include/uapi/asm/sgx.h          |  37 +++++
>>  4 files changed, 227 insertions(+)
>>  create mode 100644 arch/x86/entry/vdso/vsgx_enter_enclave.S
>>
>> diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefi=
le
>> index 657e01d34d02..fa50c76a17a8 100644
>> --- a/arch/x86/entry/vdso/Makefile
>> +++ b/arch/x86/entry/vdso/Makefile
>> @@ -24,6 +24,7 @@ VDSO32-$(CONFIG_IA32_EMULATION)       :=3D y
>>
>>  # files to link into the vdso
>>  vobjs-y :=3D vdso-note.o vclock_gettime.o vgetcpu.o
>> +vobjs-$(VDSO64-y)              +=3D vsgx_enter_enclave.o
>>
>>  # files to link into kernel
>>  obj-y                          +=3D vma.o extable.o
>> @@ -90,6 +91,7 @@ $(vobjs): KBUILD_CFLAGS :=3D $(filter-out $(GCC_PLUG=
INS_CFLAGS) $(RETPOLINE_CFLAGS
>>  CFLAGS_REMOVE_vclock_gettime.o =3D -pg
>>  CFLAGS_REMOVE_vdso32/vclock_gettime.o =3D -pg
>>  CFLAGS_REMOVE_vgetcpu.o =3D -pg
>> +CFLAGS_REMOVE_vsgx_enter_enclave.o =3D -pg
>>
>>  #
>>  # X32 processes use x32 vDSO to access 64bit kernel data.
>> diff --git a/arch/x86/entry/vdso/vdso.lds.S b/arch/x86/entry/vdso/vdso=
=2Elds.S
>> index 36b644e16272..4bf48462fca7 100644
>> --- a/arch/x86/entry/vdso/vdso.lds.S
>> +++ b/arch/x86/entry/vdso/vdso.lds.S
>> @@ -27,6 +27,7 @@ VERSION {
>>                 __vdso_time;
>>                 clock_getres;
>>                 __vdso_clock_getres;
>> +               __vdso_sgx_enter_enclave;
>>         local: *;
>>         };
>>  }
>> diff --git a/arch/x86/entry/vdso/vsgx_enter_enclave.S b/arch/x86/entry=
/vdso/vsgx_enter_enclave.S
>> new file mode 100644
>> index 000000000000..94a8e5f99961
>> --- /dev/null
>> +++ b/arch/x86/entry/vdso/vsgx_enter_enclave.S
>> @@ -0,0 +1,187 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +
>> +#include <linux/linkage.h>
>> +#include <asm/export.h>
>> +#include <asm/errno.h>
>> +
>> +#include "extable.h"
>> +
>> +#define EX_LEAF                0*8
>> +#define EX_TRAPNR      0*8+4
>> +#define EX_ERROR_CODE  0*8+6
>> +#define EX_ADDRESS     1*8
>> +
>> +.code64
>> +.section .text, "ax"
>> +
>> +/**
>> + * __vdso_sgx_enter_enclave() - Enter an SGX enclave
>> + * @leaf:      ENCLU leaf, must be EENTER or ERESUME
>> + * @tcs:       TCS, must be non-NULL
>> + * @e:         Optional struct sgx_enclave_exception instance
>> + * @handler:   Optional enclave exit handler
>> + *
>> + * **Important!**  __vdso_sgx_enter_enclave() is **NOT** compliant wi=
th the
>> + * x86-64 ABI, i.e. cannot be called from standard C code.
>> + *
>> + * Input ABI:
>> + *  @leaf      %eax
>> + *  @tcs       8(%rsp)
>> + *  @e                 0x10(%rsp)
>> + *  @handler   0x18(%rsp)
>> + *
>> + * Output ABI:
>> + *  @ret       %eax
>> + *
>> + * All general purpose registers except RAX, RBX and RCX are passed a=
s-is to
>> + * the enclave. RAX, RBX and RCX are consumed by EENTER and ERESUME a=
nd are
>> + * loaded with @leaf, asynchronous exit pointer, and @tcs respectivel=
y.
>> + *
>> + * RBP and the stack are used to anchor __vdso_sgx_enter_enclave() to=
 the
>> + * pre-enclave state, e.g. to retrieve @e and @handler after an encla=
ve exit.
>> + * All other registers are available for use by the enclave and its r=
untime,
>> + * e.g. an enclave can push additional data onto the stack (and modif=
y RSP) to
>> + * pass information to the optional exit handler (see below).
>> + *
>> + * Most exceptions reported on ENCLU, including those that occur with=
in the
>> + * enclave, are fixed up and reported synchronously instead of being =
delivered
>> + * via a standard signal. Debug Exceptions (#DB) and Breakpoints (#BP=
) are
>> + * never fixed up and are always delivered via standard signals. On s=
ynchrously
>> + * reported exceptions, -EFAULT is returned and details about the exc=
eption are
>> + * recorded in @e, the optional sgx_enclave_exception struct.
>> +
>> + * If an exit handler is provided, the handler will be invoked on syn=
chronous
>> + * exits from the enclave and for all synchronously reported exceptio=
ns. In
>> + * latter case, @e is filled prior to invoking the handler.
>> + *
>> + * The exit handler's return value is interpreted as follows:
>> + *  >0:                continue, restart __vdso_sgx_enter_enclave() w=
ith @ret as @leaf
>> + *   0:                success, return @ret to the caller
>> + *  <0:                error, return @ret to the caller
>> + *
>> + * The userspace exit handler is responsible for unwinding the stack,=
 e.g. to
>> + * pop @e, u_rsp and @tcs, prior to returning to __vdso_sgx_enter_enc=
lave().
>> + * The exit handler may also transfer control, e.g. via longjmp() or =
a C++
>> + * exception, without returning to __vdso_sgx_enter_enclave().
>> + *
>> + * Return:
>> + *  0 on success,
>> + *  -EINVAL if ENCLU leaf is not allowed,
>> + *  -EFAULT if an exception occurs on ENCLU or within the enclave
>> + *  -errno for all other negative values returned by the userspace ex=
it handler
>> + */
>> +#ifdef SGX_KERNEL_DOC
>> +/* C-style function prototype to coerce kernel-doc into parsing the c=
omment. */
>> +int __vdso_sgx_enter_enclave(int leaf, void *tcs,
>> +                            struct sgx_enclave_exception *e,
>> +                            sgx_enclave_exit_handler_t handler);
>> +#endif
>> +SYM_FUNC_START(__vdso_sgx_enter_enclave)
>=20
> Currently, the selftest has a wrapper around
> __vdso_sgx_enter_enclave() which preserves all x86-64 ABI callee-saved
> registers (CSRs), though it uses none of them. Then it calls this
> function which uses %rbx but preserves none of the CSRs. Then it jumps
> into an enclave which zeroes all these registers before returning.
> Thus:
>=20
>   1. wrapper saves all CSRs
>   2. wrapper repositions stack arguments
>   3. __vdso_sgx_enter_enclave() modifies, but does not save %rbx
>   4. selftest zeros all CSRs
>   5. wrapper loads all CSRs
>=20
> I'd like to propose instead that the enclave be responsible for saving
> and restoring CSRs. So instead of the above we have:
>   1. __vdso_sgx_enter_enclave() saves %rbx
>   2. enclave saves CSRs
>   3. enclave loads CSRs
>   4. __vdso_sgx_enter_enclave() loads %rbx
>=20
> I know that lots of other stuff happens during enclave transitions,
> but at the very least we could reduce the number of instructions
> through this critical path.

The current calling convention for __vdso_sgx_enter_enclave has been care=
fully designed to mimic just calling ENCLU[EENTER] as closely as possible=
=2E

I'm not sure why you're referring to the selftest wrapper here, that does=
n't seem relevant to me.=20

--
Jethro Beekman | Fortanix


--------------ms070905040308020906090903
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
MBwGCSqGSIb3DQEJBTEPFw0yMDAzMTExNzM4MDFaMC8GCSqGSIb3DQEJBDEiBCDj+LyyvJou
DLgK/MGd0PNezcULiFBt1C/PIO3gLlztdDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAMCRe9wxdaRN7wAgVgTtHe19pZVrMfVcNa03LtA+OO/ed558pFOSf2iPe
SVDcLN6tiMZmidi2qFQV1RW86j7GOm7jd0x8svXKcO1is2yUlwN6rdhHyG1kaT1DLi+J7dIB
HlgUXweL3i0qFdmpSGxhITvwLPY2DZsSeOVzsBhtA9/OD7jKMkVN3sJJF60xZQA4YMiaUXzl
+1SN2+ry97fpfBL8GplKSjo391OD/IoMPKTjnw2YqBN5mlhK7faggFlUUGUoIR9GyipgWn1E
S963qV/gGE8MbwYZ4sWs5ErfJ/UWtEjHVvIGZFiDGDTOVZKWkQTS9IPRw0JgSXuUac4hCQAA
AAAAAA==

--------------ms070905040308020906090903--
