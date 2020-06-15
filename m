Return-Path: <SRS0=pBxd=74=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C85CBC433DF
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Jun 2020 12:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 918CB206D7
	for <linux-sgx@archiver.kernel.org>; Mon, 15 Jun 2020 12:18:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="lkSkOtQ0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgFOMSY (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 15 Jun 2020 08:18:24 -0400
Received: from mail-bn7nam10on2128.outbound.protection.outlook.com ([40.107.92.128]:13152
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729929AbgFOMSW (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 15 Jun 2020 08:18:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BR2Tm0EJeD0v7QeznlEDRwNi1ixAZN+M4htFNlDH5XnQCkRfWC3DWHiynPqxTMftbaqb+3kZqsqaI/CF27asn1+icEa4Q5ioNzindG+Fg9wJ336Wazc4MckqATjI0t/36JJeAJVxAOJYzzNV2Mcw9pm/sI44JgcnFM2gCqkb/B8RIlzBnu9594GXAyO/s46lrKnKR88Lw7lTCbafwTPGeVcV1Pn7khn/E+GPRw7WEMTd09V1/PcJ6Uzc6QnA5/hjY6g188dzTI+be/k7t5R5Bg88GNro4jriIy7eB8J07NiIJOALZW6g4fK7DpgobIdsvn5KrScStovZhbjLf0uLZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPWcgk+kbXBhqGS0vnILcI7YWfcQF5UKJR4Gjd/FUX4=;
 b=UD+EZ6CMkyFx1R2qBxn4AIdbWSgFp2jqmePx1/jGcOXUw27Gk3DXG2EQ0A3sBj6fNn1b8vrSGDISLufKeqPzSkPyrRewOEWXncZnsKbKqj0WuvZFc3kKA0K/9jRQkpkKP4w0Iubun8f2bOkliuRIwKLpPP/JFWrvztWAsKuyin94MZN/l9XPP+ikS/yOdv7b/C6TUax/OiRYso7zJn4biGNGBaYhIBgFBWWgrxlk95gLmMfgSofp83XAZ38+9TwBhDQgUBY0ml/MNMhJeaZTEEPZOtcjrV8DoiG2BDokWlBOWxqLmIVA6Vl9C4RK9+zNZt8mJ95pvLBEZh2GIEsViQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPWcgk+kbXBhqGS0vnILcI7YWfcQF5UKJR4Gjd/FUX4=;
 b=lkSkOtQ0vBLBYE5dPcldbLdcFKkheLgXtzlbe8HUqUH5oAmZ6CqNE6PiEqeI4w1rsgk5MFnHj4+yiX94nTGaInByHzV33r567XTMWPOzhaPx9Uvqf2lkuWQyGcMuC1HCfIae5HcR93++F5oOzjAavJYJZsNlc4tFOwFqIy4j8Qo=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fortanix.com;
Received: from BY5PR11MB4260.namprd11.prod.outlook.com (2603:10b6:a03:1ba::30)
 by BY5PR11MB4324.namprd11.prod.outlook.com (2603:10b6:a03:1bd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.22; Mon, 15 Jun
 2020 12:13:36 +0000
Received: from BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::a894:6392:f99f:375c]) by BY5PR11MB4260.namprd11.prod.outlook.com
 ([fe80::a894:6392:f99f:375c%4]) with mapi id 15.20.3088.029; Mon, 15 Jun 2020
 12:13:35 +0000
Subject: Re: [PATCH v32 00/21] Intel SGX foundations
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, andriy.shevchenko@linux.intel.com,
        asapek@google.com, bp@alien8.de, cedric.xing@intel.com,
        chenalexchen@google.com, conradparker@google.com,
        cyhanish@google.com, dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, luto@kernel.org,
        nhorman@redhat.com, npmccallum@redhat.com, puiterwijk@redhat.com,
        rientjes@google.com, sean.j.christopherson@intel.com,
        tglx@linutronix.de, yaozhangx@google.com
References: <20200601075218.65618-1-jarkko.sakkinen@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <355c8c48-3dc7-5d4e-6610-390bc9188231@fortanix.com>
Date:   Mon, 15 Jun 2020 14:13:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200601075218.65618-1-jarkko.sakkinen@linux.intel.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256; boundary="------------ms090706000304060909050207"
X-ClientProxiedBy: AM4PR0902CA0008.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::18) To BY5PR11MB4260.namprd11.prod.outlook.com
 (2603:10b6:a03:1ba::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.4.219] (213.127.11.95) by AM4PR0902CA0008.eurprd09.prod.outlook.com (2603:10a6:200:9b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.19 via Frontend Transport; Mon, 15 Jun 2020 12:13:30 +0000
X-Originating-IP: [213.127.11.95]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a8d030af-f061-46ce-1abf-08d811258720
X-MS-TrafficTypeDiagnostic: BY5PR11MB4324:
X-Microsoft-Antispam-PRVS: <BY5PR11MB43248132C0F6476ED1696467AA9C0@BY5PR11MB4324.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 04359FAD81
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UlSS2fwwtZWnO4g0oocEC21l1LI79IK/Rt9L+QBVLKYS0DMKKhfGlRvcFHU52xsgr27d+AlbKO9otJJ6aoBVv7zx2up6WgEjs379byzGvzrQUDMf7fIwVeoFkeZQsPBZG/fKE+9G9hDGyz5GL7mJ9bAw56NXK3u5dSqSHlX09WJFLuXOmrMAFUDWXxcFk6BDkPjksOkDOmuZAwHwWt7iiTmtUyJHFp4Ct/lT+Mj68F1z7rJdctSK/dhaz4bf5ztHDPAnGWpQIWv6M75vCmy+ad+rkzvs5tGd4f75WZmSJaRaKmKg6L0/9YcCtY1t8snadEnaLMF2lQR4iZ8rARYAIDlopfH8fsCPkUEtnIDLIvlPdM3hNR5ZIvLPoxc2oLZ1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR11MB4260.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(376002)(136003)(366004)(396003)(39840400004)(346002)(2616005)(956004)(7416002)(30864003)(26005)(508600001)(31686004)(66556008)(66476007)(186003)(66946007)(235185007)(5660300002)(16526019)(36756003)(53546011)(31696002)(8936002)(6486002)(16576012)(8676002)(316002)(86362001)(83380400001)(6666004)(4326008)(33964004)(52116002)(2906002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 9QUQBSy8FmWeOASnJ/vuvvUS6WqiT7BbclgU52vyD2nol/rLRyZ2QZ7/mk2aF07g9QKIOVIRt8PT4kiIJdsKzSzHYtbNaNRbM7A0eml4FVA2BV9Jc2JjQSX9qHqQeyag+makc98BTpMExXbv8tEuKYsF4DDZ5KCogj0hQNW2pabljPDXE4n7Tku77q7PhpapUYsBEu+nXjSvT/O4lsBkDaC6e7cSCjVyD8WDfgGIl9WVw6fN+k0ns6kS2CdXLdTF5GfRVe5XRI6hKntcvCP7vstN67N7wGrb8CjaoiK0m68nj6JR46JdDG4xvMm1S3LD83awQpB3+Y25/Jio+v/xTMg2oObczR29Ud1HOzXxZlkbqLDGGXiGgGM6eWy62fw2AgVeNqZJrg97H0kJ3DuAnlAhhmtcccUWqQ57nHlAhmoKNndIbFvIoVlFUgauZLDy2mL20OA3rz0HWfetCrUNPYDXPs8FRhfKU1nKlR714Rk=
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8d030af-f061-46ce-1abf-08d811258720
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2020 12:13:35.6342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IdArX4Zk8nMNHnaAfB3T3hSFiE3Unq/6F+8piW9njadbLDb8M+XnbVFasAHNtBF7WC9MKMar1nFc08sNnpalBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4324
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

--------------ms090706000304060909050207
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Looks like we missed the boat for 5.8. Can we get this ready for 5.9?

--
Jethro Beekman | Fortanix

On 2020-06-01 09:51, Jarkko Sakkinen wrote:
> Intel(R) SGX is a set of CPU instructions that can be used by applicati=
ons
> to set aside private regions of code and data. The code outside the enc=
lave
> is disallowed to access the memory inside the enclave by the CPU access=

> control.
>=20
> There is a new hardware unit in the processor called Memory Encryption
> Engine (MEE) starting from the Skylake microacrhitecture. BIOS can defi=
ne
> one or many MEE regions that can hold enclave data by configuring them =
with
> PRMRR registers.
>=20
> The MEE automatically encrypts the data leaving the processor package t=
o
> the MEE regions. The data is encrypted using a random key whose life-ti=
me
> is exactly one power cycle.
>=20
> The current implementation requires that the firmware sets
> IA32_SGXLEPUBKEYHASH* MSRs as writable so that ultimately the kernel ca=
n
> decide what enclaves it wants run. The implementation does not create
> any bottlenecks to support read-only MSRs later on.
>=20
> You can tell if your CPU supports SGX by looking into /proc/cpuinfo:
>=20
> 	cat /proc/cpuinfo  | grep sgx
>=20
> v32:
> * v31 contained not fully cleaned up main.c after merger of main.c and
>   reclaim.c. Fixed in this version.
> * Rebased to v5.7. Forgot to do this for v31.
>=20
> v31:
> * Unset SGX_ENCL_IOCTL in the error path of checking encl->flags in ord=
er
>   to prevent leaving it set and thus block any further ioctl calls.
> * Added missing cleanup_srcu_struct() call to sgx_encl_release().
> * Take encl->lock in sgx_encl_add_page() in order to prevent races with=

>   the page reclaimer.
> * Fix a use-after-free bug from the page reclaimer. Call kref_put() for=

>   encl->refcount only after putting enclave page back to the active pag=
e
>   list because it could be the last ref to the enclave.
> * Filter any CPU disallowed values from sigstruct->vendor
>   SGX_IOC_ENCLAVE_INIT.
> * Use bits 0-7 of page descriptor for the EPC section index. This
>   should be enough for long term needs.
> * Refined naming for functions that allocate and free EPC pages to
>   be more sound and consistent.
> * Merge main.c and reclaim.c into one.
>=20
> v30:
> Bunch of tags added. No actual code changes.
>=20
> v29:
> * The selftest has been moved to selftests/sgx. Because SGX is an execu=
tion
>   environment of its own, it really isn't a great fit with more "standa=
rd"
>   x86 tests.
>=20
>   The RSA key is now generated on fly and the whole signing process has=

>   been made as part of the enclave loader instead of signing the enclav=
e
>   during the compilation time.
>=20
>   Finally, the enclave loader loads now the test enclave directly from =
its
>   ELF file, which means that ELF file does not need to be coverted as r=
aw
>   binary during the build process.
> * Version the mm_list instead of using on synchronize_mm() when adding =
new
>   entries. We hold the write lock for the mm_struct, and dup_mm() can t=
hus
>   deadlock with the page reclaimer, which could hold the lock for the o=
ld
>   mm_struct.
> * Disallow mmap(PROT_NONE) from /dev/sgx. Any mapping (e.g. anonymous) =
can
>   be used to reserve the address range. Now /dev/sgx supports only opaq=
ue
>   mappings to the (initialized) enclave data.
> * Make the vDSO callable directly from C by preserving RBX and taking l=
eaf
>   from RCX.
>=20
> v28:
> * Documented to Documentation/x86/sgx.rst how the kernel manages the
>   enclave ownership.
> * Removed non-LC flow from sgx_einit().
> * Removed struct sgx_einittoken since only the size of the correspondin=
g
>   microarchitectural structure is used in the series ATM.
>=20
> v27:
> * Disallow RIE processes to use enclaves as there could a permission
>   conflict between VMA and enclave permissions.
> * In the documentation, replace "grep /proc/cpuinfo" with
>   "grep sgx /proc/cpuinfo".
>=20
> v26:
> * Fixed the commit author in "x86/sgx: Linux Enclave Driver", which was=

>   changed in v25 by mistake.
> * Addressed a bunch of grammar mistakes in sgx.rst (thanks Randy once
>   again for such a detailed feedback).
> * Added back the MAINTAINERS update commit, which was mistakenly remove=
d
>   in v25.
> * EREMOVE's for SECS cannot be done while sanitizing an EPC section. Th=
e
>   CPU does not allow to remove a SECS page before all of its children h=
ave
>   been removed, and a child page can be in some other section than the =
one
>   currently being processed. Thus, removed special SECS processing from=

>   sgx_sanitize_page() and instead put sections through it twice. In the=

>   2nd round the lists should only contain SECS pages.
>=20
> v25:
> * Fix a double-free issue when SGX_IOC_ENCLAVE_ADD_PAGES
>   fails on executing ENCLS[EADD]. The rollback path executed
>   radix_tree_delete() on the same address twice when this happened.
> * Return -EINTR instead of -ERESTARTSYS in SGX_IOC_ENCLAVE_ADD_PAGES wh=
en
>   a signal is pending.
> * As requested by Borislav, move the CPUID 0x12 features to their own w=
ord
>   in cpufeatures.
> * Sean fixed a bug from sgx_reclaimer_write() where sgx_encl_put_backin=
g()
>   was called with an uninitialized pointer when sgx_encl_get_backing()
>   fails.
> * Migrated /dev/sgx/* to misc. This is future-proof as struct miscdevic=
e
>   has 'groups' for setting up sysfs attributes for the device.
> * Use device_initcall instead of subsys_initcall so that misc_class is
>   initialized before SGX is initialized.
> * Return -EACCES in SGX_IOC_ENCLAVE_INIT when caller tries to select
>   enclave attributes that we the kernel does not allow it to set instea=
d
>   of -EINVAL.
> * Unless SGX public key MSRs are writable always deny the feature from
>   Linux. Previously this was only denied from driver. How VMs should be=

>   supported is not really part of initial patch set, which makes this
>   an obvious choice.
> * Cleaned up and refined documentation to be more approachable.
>=20
> v24:
> * Reclaim unmeasured and TCS pages (regression in v23).
> * Replace usages of GFP_HIGHUSER with GFP_KERNEL.
> * Return -EIO on when EADD or EEXTEND fails in %SGX_IOC_ENCLAVE_ADD_PAG=
ES
>   and use the same rollback (destroy enclave). This can happen when hos=
t
>   suspends itself unknowingly to a VM running enclaves. From -EIO the u=
ser
>   space can deduce what happened.
> * Have a separate @count in struct sgx_enclave_add_pages to output numb=
er
>   of bytes processed instead of overwriting the input parameters for
>   clarity and more importantly that the API provides means for partial
>   processing (@count could be less than @length in success case).
>=20
> v23:
> * Replace SGX_ENCLAVE_ADD_PAGE with SGX_ENCLAVE_ADD_PAGES. Replace @mrm=
ask
>   with %SGX_PAGE_MEASURE flag.
> * Return -EIO instead of -ECANCELED when ptrace() fails to read a TCS p=
age.
> * In the reclaimer, pin page before ENCLS[EBLOCK] because pinning can f=
ail
>   (because of OOM) even in legit behaviour and after EBLOCK the reclaim=
ing
>   flow can be only reverted by killing the whole enclave.
> * Fixed SGX_ATTR_RESERVED_MASK. Bit 7 was marked as reserved while in f=
act
>   it should have been bit 6 (Table 37-3 in the SDM).
> * Return -EPERM from SGX_IOC_ENCLAVE_INIT when ENCLS[EINIT] returns an =
SGX
>   error code.
>=20
> v22:
> * Refined bunch commit messages and added associated SDM references as
>   many of them were too exhausting and some outdated.
> * Alignment checks have been removed from mmap() because it does not de=
fine
>   the ELRANGE. VMAs only act as windows to the enclave. The semantics
>   compare somewhat how mmap() works with regular files.
> * We now require user space addresses given to SGX_IOC_ENCLAVE_ADD_PAGE=
 to be
>   page aligned so that we can pass the page directly to EADD and do not=
 have
>   to do an extra copy. This was made effectively possible by removing t=
he
>   worker thread for adding pages.
> * The selftest build files have been refined throughout of various glit=
ches
>   and work properly in a cross compilation environment such as BuildRoo=
t.
>   In addition, libcalls fail the build with an assertion in the linker
>   script, if they end up to the enclave binary.
> * CONFIG_INTEL_SGX_DRIVER has been removed because you cannot use SGX c=
ore
>   for anything without having the driver. This could change when KVM su=
pport
>   is added.
> * We require zero permissions in SECINFO for TCS pages because the CPU
>   overwrites SECINFO flags with zero permissions and measures the page
>   only after that. Allowing to pass TCS with non-zero permissions would=

>   cause mismatching measurement between the one provided in SIGSTRUCT a=
nd
>   the one computed by the CPU.
> * Obviously lots of small fixes and clean ups (does make sense to
>   document them all).
>=20
> v21:
> * Check on mmap() that the VMA does cover an area that does not have
>   enclave pages. Only mapping with PROT_NONE can do that to reserve
>   initial address space for an enclave.
> * Check om mmap() and mprotect() that the VMA permissions do not
>   surpass the enclave permissions.
> * Remove two refcounts from vma_close(): mm_list and encl->refcount.
>   Enclave refcount is only need for swapper/enclave sync and we can
>   remove mm_list refcount by destroying mm_struct when the process
>   is closed. By not having vm_close() the Linux MM can merge VMAs.
> * Do not naturally align MAP_FIXED address.
> * Numerous small fixes and clean ups.
> * Use SRCU for synchronizing the list of mm_struct's.
> * Move to stack based call convention in the vDSO.
>=20
> v20:
> * Fine-tune Kconfig messages and spacing and remove MMU_NOTIFIER
>   dependency as MMU notifiers are no longer used in the driver.
> * Use mm_users instead of mm_count as refcount for mm_struct as mm_coun=
t
>   only protects from deleting mm_struct, not removing its contents.
> * Sanitize EPC when the reclaimer thread starts by doing EREMOVE for al=
l
>   of them. They could be in initialized state when the kernel starts
>   because it might be spawned by kexec().
> * Documentation overhaul.
> * Use a device /dev/sgx/provision for delivering the provision token
>   instead of securityfs.
> * Create a reference to the enclave when already when opening
>   /dev/sgx/enclave.  The file is then associated with this enclave only=
=2E
>   mmap() can be done at free at any point and always get a reference to=

>   the enclave. To summarize the file now represents the enclave.
>=20
> v19:
> * Took 3-4 months but in some sense this was more like a rewrite of mos=
t
>   of the corners of the source code. If I've forgotten to deal with som=
e
>   feedback, please don't shout me. Make a remark and I will fix it for
>   the next version. Hopefully there won't be this big turnovers anymore=
=2E
> * Validate SECS attributes properly against CPUID given attributes and
>   against allowed attributes. SECS attributes are the ones that are
>   enforced whereas SIGSTRUCT attributes tell what is required to run
>   the enclave.
> * Add KSS (Key Sharing Support) to the enclave attributes.
> * Deny MAP_PRIVATE as an enclave is always a shared memory entity.
> * Revert back to shmem backing storage so that it can be easily shared
>   by multiple processes.
> * Split the recognization of an ENCLS leaf failure by using three
>   functions to detect it: encsl_faulted(), encls_returned_code() and
>   sgx_failed(). encls_failed() is only caused by a spurious expections =
that
>   should never happen. Thus, it is not defined as an inline function in=

>   order to easily insert a kprobe to it.
> * Move low-level enclave management routines, page fault handler and pa=
ge
>   reclaiming routines from driver to the core. These cannot be separate=
d
>   from each other as they are heavily interdependent. The rationale is =
that
>   the core does not call any code from the driver.
> * Allow the driver to be compiled as a module now that it no code is us=
ing
>   its routines and it only uses exported symbols. Now the driver is
>   essentially just a thin ioctl layer.
> * Reworked the driver to maintain a list of mm_struct's. The VMA callba=
cks
>   add new entries to this list as the process is forked. Each entry has=

>   its own refcount because they have a different life-cycle as the encl=
ave
>   does. In effect @tgid and @mm have been removed from struct sgx_encl
>   and we allow forking by removing VM_DONTCOPY from vm flags.
> * Generate a cpu mask in the reclaimer from the cpu mask's of all
>   mm_struct's. This will kick out the hardware threads out of the encla=
ve
>   from multiple processes. It is not a local variable because it would
>   eat too much of the stack space but instead a field in struct
>   sgx_encl.
> * Allow forking i.e. remove VM_DONTCOPY. I did not change the API
>   because the old API scaled to the workload that Andy described. The
>   codebase is now mostly API independent i.e. changing the API is a
>   small task. For me the proper trigger to chanage it is a as concrete
>   as possible workload that cannot be fulfilled. I hope you understand
>   my thinking here. I don't want to change anything w/o proper basis
>   but I'm ready to change anything if there is a proper basis. I do
>   not have any kind of attachment to any particular type of API.
> * Add Sean's vDSO ENCLS(EENTER) patches and update selftest to use the
>   new vDSO.
>=20
> v18:
> * Update the ioctl-number.txt.
> * Move the driver under arch/x86.
> * Add SGX features (SGX, SGX1, SGX2) to the disabled-features.h.
> * Rename the selftest as test_sgx (previously sgx-selftest).
> * In order to enable process accounting, swap EPC pages and PCMD's to a=
 VMA
>   instead of shmem.
> * Allow only to initialize and run enclaves with a subset of
>   {DEBUG, MODE64BIT} set.
> * Add SGX_IOC_ENCLAVE_SET_ATTRIBUTE to allow an enclave to have privile=
ged
>   attributes e.g. PROVISIONKEY.
>=20
> v17:
> * Add a simple selftest.
> * Fix a null pointer dereference to section->pages when its
>   allocation fails.
> * Add Sean's description of the exception handling to the documentation=
=2E
>=20
> v16:
> * Fixed SOB's in the commits that were a bit corrupted in v15.
> * Implemented exceptio handling properly to detect_sgx().
> * Use GENMASK() to define SGX_CPUID_SUB_LEAF_TYPE_MASK.
> * Updated the documentation to use rst definition lists.
> * Added the missing Documentation/x86/index.rst, which has a link to
>   intel_sgx.rst. Now the SGX and uapi documentation is properly generat=
ed
>   with 'make htmldocs'.
> * While enumerating EPC sections, if an undefined section is found, fai=
l
>   the driver initialization instead of continuing the initialization.
> * Issue a warning if there are more than %SGX_MAX_EPC_SECTIONS.
> * Remove copyright notice from arch/x86/include/asm/sgx.h.
> * Migrated from ioremap_cache() to memremap().
>=20
> v15:
> * Split into more digestable size patches.
> * Lots of small fixes and clean ups.
> * Signal a "plain" SIGSEGV on an EPCM violation.
>=20
> v14:
> * Change the comment about X86_FEATURE_SGX_LC from =E2=80=9CSGX launch
>   configuration=E2=80=9D to =E2=80=9CSGX launch control=E2=80=9D.
> * Move the SGX-related CPU feature flags as part of the Linux defined
>   virtual leaf 8.
> * Add SGX_ prefix to the constants defining the ENCLS leaf functions.
> * Use GENMASK*() and BIT*() in sgx_arch.h instead of raw hex numbers.
> * Refine the long description for CONFIG_INTEL_SGX_CORE.
> * Do not use pr_*_ratelimited()  in the driver. The use of the rate lim=
ited
>   versions is legacy cruft from the prototyping phase.
> * Detect sleep with SGX_INVALID_EINIT_TOKEN instead of counting power
>   cycles.
> * Manually prefix with =E2=80=9Csgx:=E2=80=9D in the core SGX code inst=
ead of redefining
>   pr_fmt.
> * Report if IA32_SGXLEPUBKEYHASHx MSRs are not writable in the driver
>   instead of core because it is a driver requirement.
> * Change prompt to bool in the entry for CONFIG_INTEL_SGX_CORE because =
the
>   default is =E2=80=98n=E2=80=99.
> * Rename struct sgx_epc_bank as struct sgx_epc_section in order to matc=
h
>   the SDM.
> * Allocate struct sgx_epc_page instances one at a time.
> * Use =E2=80=9C__iomem void *=E2=80=9D pointers for the mapped EPC memo=
ry consistently.
> * Retry once on SGX_INVALID_TOKEN in sgx_einit() instead of counting po=
wer
>   cycles.
> * Call enclave swapping operations directly from the driver instead of
>   calling them .indirectly through struct sgx_epc_page_ops because indi=
rect
>   calls are not required yet as the patch set does not contain the KVM
>   support.
> * Added special signal SEGV_SGXERR to notify about SGX EPCM violation
>   errors.
>=20
> v13:
> * Always use SGX_CPUID constant instead of a hardcoded value.
> * Simplified and documented the macros and functions for ENCLS leaves.
> * Enable sgx_free_page() to free active enclave pages on demand
>   in order to allow sgx_invalidate() to delete enclave pages.
>   It no longer performs EREMOVE if a page is in the process of
>   being reclaimed.
> * Use PM notifier per enclave so that we don't have to traverse
>   the global list of active EPC pages to find enclaves.
> * Removed unused SGX_LE_ROLLBACK constant from uapi/asm/sgx.h
> * Always use ioremap() to map EPC banks as we only support 64-bit kerne=
l.
> * Invalidate IA32_SGXLEPUBKEYHASH cache used by sgx_einit() when going
>   to sleep.
>=20
> v12:
> * Split to more narrow scoped commits in order to ease the review proce=
ss and
>   use co-developed-by tag for co-authors of commits instead of listing =
them in
>   the source files.
> * Removed cruft EXPORT_SYMBOL() declarations and converted to static va=
riables.
> * Removed in-kernel LE i.e. this version of the SGX software stack only=

>   supports unlocked IA32_SGXLEPUBKEYHASHx MSRs.
> * Refined documentation on launching enclaves, swapping and enclave
>   construction.
> * Refined sgx_arch.h to include alignment information for every struct =
that
>   requires it and removed structs that are not needed without an LE.
> * Got rid of SGX_CPUID.
> * SGX detection now prints log messages about firmware configuration is=
sues.
>=20
> v11:
> * Polished ENCLS wrappers with refined exception handling.
> * ksgxswapd was not stopped (regression in v5) in
>   sgx_page_cache_teardown(), which causes a leaked kthread after driver=

>   deinitialization.
> * Shutdown sgx_le_proxy when going to suspend because its EPC pages wil=
l be
>   invalidated when resuming, which will cause it not function properly
>   anymore.
> * Set EINITTOKEN.VALID to zero for a token that is passed when
>   SGXLEPUBKEYHASH matches MRSIGNER as alloc_page() does not give a zero=

>   page.
> * Fixed the check in sgx_edbgrd() for a TCS page. Allowed to read offse=
ts
>   around the flags field, which causes a #GP. Only flags read is readab=
le.
> * On read access memcpy() call inside sgx_vma_access() had src and dest=

>   parameters in wrong order.
> * The build issue with CONFIG_KASAN is now fixed. Added undefined symbo=
ls
>   to LE even if =E2=80=9CKASAN_SANITIZE :=3D false=E2=80=9D was set in =
the makefile.
> * Fixed a regression in the #PF handler. If a page has
>   SGX_ENCL_PAGE_RESERVED flag the #PF handler should unconditionally fa=
il.
>   It did not, which caused weird races when trying to change other part=
s of
>   swapping code.
> * EPC management has been refactored to a flat LRU cache and moved to
>   arch/x86. The swapper thread reads a cluster of EPC pages and swaps a=
ll
>   of them. It can now swap from multiple enclaves in the same round.
> * For the sake of consistency with SGX_IOC_ENCLAVE_ADD_PAGE, return -EI=
NVAL
>   when an enclave is already initialized or dead instead of zero.
>=20
> v10:
> * Cleaned up anon inode based IPC between the ring-0 and ring-3 parts
>   of the driver.
> * Unset the reserved flag from an enclave page if EDBGRD/WR fails
>   (regression in v6).
> * Close the anon inode when LE is stopped (regression in v9).
> * Update the documentation with a more detailed description of SGX.
>=20
> v9:
> * Replaced kernel-LE IPC based on pipes with an anonymous inode.
>   The driver does not require anymore new exports.
>=20
> v8:
> * Check that public key MSRs match the LE public key hash in the
>   driver initialization when the MSRs are read-only.
> * Fix the race in VA slot allocation by checking the fullness
>   immediately after succeesful allocation.
> * Fix the race in hash mrsigner calculation between the launch
>   enclave and user enclaves by having a separate lock for hash
>   calculation.
>=20
> v7:
> * Fixed offset calculation in sgx_edbgr/wr(). Address was masked with P=
AGE_MASK
>   when it should have been masked with ~PAGE_MASK.
> * Fixed a memory leak in sgx_ioc_enclave_create().
> * Simplified swapping code by using a pointer array for a cluster
>   instead of a linked list.
> * Squeezed struct sgx_encl_page to 32 bytes.
> * Fixed deferencing of an RSA key on OpenSSL 1.1.0.
> * Modified TC's CMAC to use kernel AES-NI. Restructured the code
>   a bit in order to better align with kernel conventions.
>=20
> v6:
> * Fixed semaphore underrun when accessing /dev/sgx from the launch encl=
ave.
> * In sgx_encl_create() s/IS_ERR(secs)/IS_ERR(encl)/.
> * Removed virtualization chapter from the documentation.
> * Changed the default filename for the signing key as signing_key.pem.
> * Reworked EPC management in a way that instead of a linked list of
>   struct sgx_epc_page instances there is an array of integers that
>   encodes address and bank of an EPC page (the same data as 'pa' field
>   earlier). The locking has been moved to the EPC bank level instead
>   of a global lock.
> * Relaxed locking requirements for EPC management. EPC pages can be
>   released back to the EPC bank concurrently.
> * Cleaned up ptrace() code.
> * Refined commit messages for new architectural constants.
> * Sorted includes in every source file.
> * Sorted local variable declarations according to the line length in
>   every function.
> * Style fixes based on Darren's comments to sgx_le.c.
>=20
> v5:
> * Described IPC between the Launch Enclave and kernel in the commit mes=
sages.
> * Fixed all relevant checkpatch.pl issues that I have forgot fix in ear=
lier
>   versions except those that exist in the imported TinyCrypt code.
> * Fixed spelling mistakes in the documentation.
> * Forgot to check the return value of sgx_drv_subsys_init().
> * Encapsulated properly page cache init and teardown.
> * Collect epc pages to a temp list in sgx_add_epc_bank
> * Removed SGX_ENCLAVE_INIT_ARCH constant.
>=20
> v4:
> * Tied life-cycle of the sgx_le_proxy process to /dev/sgx.
> * Removed __exit annotation from sgx_drv_subsys_exit().
> * Fixed a leak of a backing page in sgx_process_add_page_req() in the
>   case when vm_insert_pfn() fails.
> * Removed unused symbol exports for sgx_page_cache.c.
> * Updated sgx_alloc_page() to require encl parameter and documented the=

>   behavior (Sean Christopherson).
> * Refactored a more lean API for sgx_encl_find() and documented the beh=
avior.
> * Moved #PF handler to sgx_fault.c.
> * Replaced subsys_system_register() with plain bus_register().
> * Retry EINIT 2nd time only if MSRs are not locked.
>=20
> v3:
> * Check that FEATURE_CONTROL_LOCKED and FEATURE_CONTROL_SGX_ENABLE are =
set.
> * Return -ERESTARTSYS in __sgx_encl_add_page() when sgx_alloc_page() fa=
ils.
> * Use unused bits in epc_page->pa to store the bank number.
> * Removed #ifdef for WQ_NONREENTRANT.
> * If mmu_notifier_register() fails with -EINTR, return -ERESTARTSYS.
> * Added --remove-section=3D.got.plt to objcopy flags in order to preven=
t a
>   dummy .got.plt, which will cause an inconsistent size for the LE.
> * Documented sgx_encl_* functions.
> * Added remark about AES implementation used inside the LE.
> * Removed redundant sgx_sys_exit() from le/main.c.
> * Fixed struct sgx_secinfo alignment from 128 to 64 bytes.
> * Validate miscselect in sgx_encl_create().
> * Fixed SSA frame size calculation to take the misc region into account=
=2E
> * Implemented consistent exception handling to __encls() and __encls_re=
t().
> * Implemented a proper device model in order to allow sysfs attributes
>   and in-kernel API.
> * Cleaned up various "find enclave" implementations to the unified
>   sgx_encl_find().
> * Validate that vm_pgoff is zero.
> * Discard backing pages with shmem_truncate_range() after EADD.
> * Added missing EEXTEND operations to LE signing and launch.
> * Fixed SSA size for GPRS region from 168 to 184 bytes.
> * Fixed the checks for TCS flags. Now DBGOPTIN is allowed.
> * Check that TCS addresses are in ELRANGE and not just page aligned.
> * Require kernel to be compiled with X64_64 and CPU_SUP_INTEL.
> * Fixed an incorrect value for SGX_ATTR_DEBUG from 0x01 to 0x02.
>=20
> v2:
> * get_rand_uint32() changed the value of the pointer instead of value
>   where it is pointing at.
> * Launch enclave incorrectly used sigstruct attributes-field instead of=

>   enclave attributes-field.
> * Removed unused struct sgx_add_page_req from sgx_ioctl.c
> * Removed unused sgx_has_sgx2.
> * Updated arch/x86/include/asm/sgx.h so that it provides stub
>   implementations when sgx in not enabled.
> * Removed cruft rdmsr-calls from sgx_set_pubkeyhash_msrs().
> * return -ENOMEM in sgx_alloc_page() when VA pages consume too much spa=
ce
> * removed unused global sgx_nr_pids
> * moved sgx_encl_release to sgx_encl.c
> * return -ERESTARTSYS instead of -EINTR in sgx_encl_init()
>=20
> Jarkko Sakkinen (11):
>   x86/sgx: Add SGX microarchitectural data structures
>   x86/sgx: Add wrappers for ENCLS leaf functions
>   x86/cpu/intel: Add nosgx kernel parameter
>   x86/sgx: Add __sgx_alloc_epc_page() and sgx_free_epc_page()
>   x86/sgx: Linux Enclave Driver
>   x86/sgx: Add provisioning
>   x86/sgx: Add a page reclaimer
>   x86/sgx: ptrace() support for the SGX driver
>   selftests/x86: Add a selftest for SGX
>   docs: x86/sgx: Document SGX micro architecture and kernel internals
>   x86/sgx: Update MAINTAINERS
>=20
> Sean Christopherson (10):
>   x86/cpufeatures: x86/msr: Add Intel SGX hardware bits
>   x86/cpufeatures: x86/msr: Add Intel SGX Launch Control hardware bits
>   x86/mm: x86/sgx: Signal SIGSEGV with PF_SGX
>   x86/cpu/intel: Detect SGX support
>   x86/sgx: Initialize metadata for Enclave Page Cache (EPC) sections
>   mm: Introduce vm_ops->may_mprotect()
>   x86/vdso: Add support for exception fixup in vDSO functions
>   x86/fault: Add helper function to sanitize error code
>   x86/traps: Attempt to fixup exceptions in vDSO before signaling
>   x86/vdso: Implement a vDSO for Intel SGX enclave call
>=20
>  .../admin-guide/kernel-parameters.txt         |   2 +
>  .../userspace-api/ioctl/ioctl-number.rst      |   1 +
>  Documentation/x86/index.rst                   |   1 +
>  Documentation/x86/sgx.rst                     | 206 +++++
>  MAINTAINERS                                   |  11 +
>  arch/x86/Kconfig                              |  16 +
>  arch/x86/entry/vdso/Makefile                  |   8 +-
>  arch/x86/entry/vdso/extable.c                 |  46 +
>  arch/x86/entry/vdso/extable.h                 |  29 +
>  arch/x86/entry/vdso/vdso-layout.lds.S         |   9 +-
>  arch/x86/entry/vdso/vdso.lds.S                |   1 +
>  arch/x86/entry/vdso/vdso2c.h                  |  58 +-
>  arch/x86/entry/vdso/vsgx_enter_enclave.S      | 131 +++
>  arch/x86/include/asm/cpufeature.h             |   5 +-
>  arch/x86/include/asm/cpufeatures.h            |   8 +-
>  arch/x86/include/asm/disabled-features.h      |  18 +-
>  arch/x86/include/asm/enclu.h                  |   8 +
>  arch/x86/include/asm/msr-index.h              |   8 +
>  arch/x86/include/asm/required-features.h      |   2 +-
>  arch/x86/include/asm/traps.h                  |   1 +
>  arch/x86/include/asm/vdso.h                   |   5 +
>  arch/x86/include/uapi/asm/sgx.h               | 175 ++++
>  arch/x86/kernel/cpu/Makefile                  |   1 +
>  arch/x86/kernel/cpu/common.c                  |   4 +
>  arch/x86/kernel/cpu/feat_ctl.c                |  41 +-
>  arch/x86/kernel/cpu/sgx/Makefile              |   5 +
>  arch/x86/kernel/cpu/sgx/arch.h                | 343 ++++++++
>  arch/x86/kernel/cpu/sgx/driver.c              | 209 +++++
>  arch/x86/kernel/cpu/sgx/driver.h              |  32 +
>  arch/x86/kernel/cpu/sgx/encl.c                | 758 ++++++++++++++++
>  arch/x86/kernel/cpu/sgx/encl.h                | 128 +++
>  arch/x86/kernel/cpu/sgx/encls.h               | 238 +++++
>  arch/x86/kernel/cpu/sgx/ioctl.c               | 819 ++++++++++++++++++=

>  arch/x86/kernel/cpu/sgx/main.c                | 753 ++++++++++++++++
>  arch/x86/kernel/cpu/sgx/sgx.h                 |  65 ++
>  arch/x86/kernel/traps.c                       |  14 +
>  arch/x86/mm/fault.c                           |  45 +-
>  include/linux/mm.h                            |   2 +
>  mm/mprotect.c                                 |  14 +-
>  tools/arch/x86/include/asm/cpufeatures.h      |   7 +-
>  tools/testing/selftests/Makefile              |   1 +
>  tools/testing/selftests/sgx/.gitignore        |   2 +
>  tools/testing/selftests/sgx/Makefile          |  53 ++
>  tools/testing/selftests/sgx/call.S            |  54 ++
>  tools/testing/selftests/sgx/defines.h         |  21 +
>  tools/testing/selftests/sgx/load.c            | 282 ++++++
>  tools/testing/selftests/sgx/main.c            | 199 +++++
>  tools/testing/selftests/sgx/main.h            |  38 +
>  tools/testing/selftests/sgx/sigstruct.c       | 395 +++++++++
>  tools/testing/selftests/sgx/test_encl.c       |  20 +
>  tools/testing/selftests/sgx/test_encl.lds     |  40 +
>  .../selftests/sgx/test_encl_bootstrap.S       |  89 ++
>  52 files changed, 5390 insertions(+), 31 deletions(-)
>  create mode 100644 Documentation/x86/sgx.rst
>  create mode 100644 arch/x86/entry/vdso/extable.c
>  create mode 100644 arch/x86/entry/vdso/extable.h
>  create mode 100644 arch/x86/entry/vdso/vsgx_enter_enclave.S
>  create mode 100644 arch/x86/include/asm/enclu.h
>  create mode 100644 arch/x86/include/uapi/asm/sgx.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/Makefile
>  create mode 100644 arch/x86/kernel/cpu/sgx/arch.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/driver.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/driver.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/encl.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/encl.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/encls.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/ioctl.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/main.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/sgx.h
>  create mode 100644 tools/testing/selftests/sgx/.gitignore
>  create mode 100644 tools/testing/selftests/sgx/Makefile
>  create mode 100644 tools/testing/selftests/sgx/call.S
>  create mode 100644 tools/testing/selftests/sgx/defines.h
>  create mode 100644 tools/testing/selftests/sgx/load.c
>  create mode 100644 tools/testing/selftests/sgx/main.c
>  create mode 100644 tools/testing/selftests/sgx/main.h
>  create mode 100644 tools/testing/selftests/sgx/sigstruct.c
>  create mode 100644 tools/testing/selftests/sgx/test_encl.c
>  create mode 100644 tools/testing/selftests/sgx/test_encl.lds
>  create mode 100644 tools/testing/selftests/sgx/test_encl_bootstrap.S
>=20


--------------ms090706000304060909050207
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
MBwGCSqGSIb3DQEJBTEPFw0yMDA2MTUxMjEzMjNaMC8GCSqGSIb3DQEJBDEiBCBKQpwehIbW
iFRw4PiXVMJ/eWFeeraMQcYkvsqBHEfbCTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQB
KjALBglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMC
AgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGoBgkrBgEEAYI3EAQxgZowgZcwgYIxCzAJ
BgNVBAYTAklUMQ8wDQYDVQQIDAZNaWxhbm8xDzANBgNVBAcMBk1pbGFubzEjMCEGA1UECgwa
QWN0YWxpcyBTLnAuQS4vMDMzNTg1MjA5NjcxLDAqBgNVBAMMI0FjdGFsaXMgQ2xpZW50IEF1
dGhlbnRpY2F0aW9uIENBIEcxAhAFFr+cC0ZYZTtbKgQCBwyyMIGqBgsqhkiG9w0BCRACCzGB
mqCBlzCBgjELMAkGA1UEBhMCSVQxDzANBgNVBAgMBk1pbGFubzEPMA0GA1UEBwwGTWlsYW5v
MSMwIQYDVQQKDBpBY3RhbGlzIFMucC5BLi8wMzM1ODUyMDk2NzEsMCoGA1UEAwwjQWN0YWxp
cyBDbGllbnQgQXV0aGVudGljYXRpb24gQ0EgRzECEAUWv5wLRlhlO1sqBAIHDLIwDQYJKoZI
hvcNAQEBBQAEggEAv2UgRGd5SiRhCLlx+oH4AcgqtMQxZo7exvDlVF2kPz/aFC6Lq1eqLkvA
RZVuRv6V9tsIb8t6OEC2xn+Begm1goKfWebEleGEPPwQucstwpsHAX3yLkOTRxa/MXLgtAnQ
ylyFsrjcuL/RldeuP+e58gaIaI3KSW7bKYBFdOzxJsM5UUYf/0GKpiErOWzGUjiBiVQXhIdM
x86Bl3sDgdY6+5KHmOKmXTKOF7yikyDF7LjY3z3JZyMN63DkIcOPynSRFOZdimv0ELICco9x
1cUW5RwDdfUoA9BmbaMMXnsZA1gjNjiFIs6NVOmcgvMTIHZr2g2yucttf4WDhEsNdh3TbgAA
AAAAAA==

--------------ms090706000304060909050207--
