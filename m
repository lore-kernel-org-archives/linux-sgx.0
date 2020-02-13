Return-Path: <SRS0=OjbW=4B=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B7C4C2BA83
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Feb 2020 14:00:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D7DF2168B
	for <linux-sgx@archiver.kernel.org>; Thu, 13 Feb 2020 14:00:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=fortanix.onmicrosoft.com header.i=@fortanix.onmicrosoft.com header.b="SoYPC9wW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730163AbgBMOAH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 13 Feb 2020 09:00:07 -0500
Received: from mail-co1nam11on2120.outbound.protection.outlook.com ([40.107.220.120]:44128
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730036AbgBMOAH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 13 Feb 2020 09:00:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZHALXOmemsJToDTcHfbLo7Wi/l4EhZTPgzsT7ApFAPJoNasdiXj+LB9cVizzMX6Nu8NXQM1LcPrxzNjdeVNmnYVYlco7noqO67HzwhttupyX2sTvFfR9Wt83qo4Z9+RgcXDji1uN0T9xZZJMbuXifz5QCVTkTrxUYqJ0yOWIexHVPGcqiD3oXPv5Ty/5ZhPhAi3+D83NlQIS9flGKymUcWifZwLWWSFhoTlQpoRsH4BJnYyCjwvqHYxNcytw23mS+eNhEQ8q4/I1Iu+FTcv+4ekHdUwwg+J92oM8G2tQpo99bzVkvYgr/rdEeyMQAvMQut8w9MN9C80SewWLZFclTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NIU37tZkVlHbyFJyTV4+QGUxuhrr/iXpGQSs/ZgSVII=;
 b=SH1hi6DRAzn+r807dBFvDueRTbj2EHyh+oVmevaDVC6azSGO6lphRhd2lHsVgW6aRKqTS/GWc0C/+kyibRWjm4zHazNNdbIXoUfeWo570uE8+5ouOOlCXSZ/GgpgbssXcFuACp8Xb1WPXQp+1AjMjMxfQxqSu9G7cFCoGxQWbPZqOTPOUW+es5sOWRRZLUwoNVQp1QvqP0AU3S8JhxJfSCvmgcIt5b/Mcyxjvvx7fZpHbyLZW3VNeZegXCz9K8B7MikdhW65r1cmUNY8vPCsKDwmnBiVkf2iDF0zZPzxxzIHSdF0fhVZsRVUMk6EBri1oWKbjwS+yVYqIdjmR3enLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fortanix.com; dmarc=pass action=none header.from=fortanix.com;
 dkim=pass header.d=fortanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=fortanix.onmicrosoft.com; s=selector2-fortanix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NIU37tZkVlHbyFJyTV4+QGUxuhrr/iXpGQSs/ZgSVII=;
 b=SoYPC9wWWhICakNycVVNrGNzILFQoRPiWuQxTC9jMu1U4IDVQuMh5/KmfL7vt1rSQ8DIrrqIbBKKmmcvPMMMY5fZMfkXUNQ4prnD+1Q3sYyJWkdF3/4sMWkKlas8v2rqFtCTIiknmKdPDo8Pt7i3DZQA3NUqPAVD2tTfqYuhcvQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jethro@fortanix.com; 
Received: from BYAPR11MB3734.namprd11.prod.outlook.com (20.178.239.29) by
 BYAPR11MB2919.namprd11.prod.outlook.com (20.177.226.213) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Thu, 13 Feb 2020 14:00:02 +0000
Received: from BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::180:d484:4d3f:fd99]) by BYAPR11MB3734.namprd11.prod.outlook.com
 ([fe80::180:d484:4d3f:fd99%7]) with mapi id 15.20.2729.025; Thu, 13 Feb 2020
 14:00:02 +0000
Subject: Re: [PATCH v26 10/22] x86/sgx: Linux Enclave Driver
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
References: <20200209212609.7928-1-jarkko.sakkinen@linux.intel.com>
 <20200209212609.7928-11-jarkko.sakkinen@linux.intel.com>
From:   Jethro Beekman <jethro@fortanix.com>
Message-ID: <d17c50a7-6900-731b-43a2-d6e49b8eb44d@fortanix.com>
Date:   Thu, 13 Feb 2020 14:59:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
In-Reply-To: <20200209212609.7928-11-jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0218.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::14) To BYAPR11MB3734.namprd11.prod.outlook.com
 (2603:10b6:a03:fe::29)
MIME-Version: 1.0
Received: from [10.195.0.226] (212.61.132.179) by LO2P265CA0218.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:b::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Thu, 13 Feb 2020 13:59:57 +0000
X-Originating-IP: [212.61.132.179]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c421f50-3b1a-4975-c01e-08d7b08d04f8
X-MS-TrafficTypeDiagnostic: BYAPR11MB2919:
X-Microsoft-Antispam-PRVS: <BYAPR11MB29195A8170A0131131468CCEAA1A0@BYAPR11MB2919.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 031257FE13
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(396003)(136003)(39830400003)(366004)(346002)(376002)(199004)(189003)(8676002)(66476007)(52116002)(26005)(54906003)(66946007)(186003)(4001150100001)(508600001)(31686004)(53546011)(16576012)(316002)(16526019)(66556008)(7416002)(6486002)(36756003)(8936002)(2906002)(86362001)(31696002)(4326008)(2616005)(6666004)(81156014)(81166006)(5660300002)(956004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR11MB2919;H:BYAPR11MB3734.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: fortanix.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +dmZiQkJICCYzCoXtRv6KDoBK0BzSYEa7VKJZ7G6cBkEwt4oxUecQMntEpMw7eXCBjX5MrDVU2flJPmJp5hBzFsZRPDql5/PkxqSv28fsR+Sr/88ScmF1W+UlyHzo3upcVfNvDjNGJQiw2CDKy/IY8qnxX47ULho9OvYK6f6rx7rGknb+2MR367xcPmDERHbmuk8xvFvJSk4usL/ALUzE8DbQbNGGcUXncELcW/kduN+f/t0Rx1LhAEbvB07ea1mSZMrQHca21CUnfWCPtwKUWUpLN9Ay679mfRwMH+wOXuJXM21hCKru4d00tN7ytWjBZKqI8Q15AiByc8f7HrAtDQk5BuTe0t9lxfggYmr71CYfV/dXKPc5MoBymYajmSum/Zzo9ARA9DXU3MV7xomRF51EBqAS3OXuKpsEVI4F2JyQ6Qt0QGsSm9qpofB1oqE
X-MS-Exchange-AntiSpam-MessageData: zfsLGCFPonbQozrX+1oZjs3HHOgGgundyWmCCIjPuDgTLpES5f3/EVWqBN3Wlrw5wFyzFZKahmGoFotTZtjTDjVfQlFMQYLyGN60+bgCMuLPQdCpZDiVLXb1sACRUgoKHgzPokA+lvbDmo2r4x3z4A==
X-OriginatorOrg: fortanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c421f50-3b1a-4975-c01e-08d7b08d04f8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2020 14:00:02.0570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: de7becae-4883-43e8-82c7-7dbdbb988ae6
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hwWytOlp9mwfjxrJ9bNkNuQnd0kT5PpwHlbmCPz9f30pHozYYTcC/Ksf1JuGuGiWOUWoQde4Aqk6ZfJAguX5aQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB2919
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On 2020-02-09 22:25, Jarkko Sakkinen wrote:
> Intel Software Guard eXtensions (SGX) is a set of CPU instructions that
> can be used by applications to set aside private regions of code and
> data. The code outside the SGX hosted software entity is disallowed to
> access the memory inside the enclave enforced by the CPU. We call these
> entities as enclaves.
> 
> This commit implements a driver that provides an ioctl API to construct
> and run enclaves. Enclaves are constructed from pages residing in
> reserved physical memory areas. The contents of these pages can only be
> accessed when they are mapped as part of an enclave, by a hardware
> thread running inside the enclave.
> 
> The starting state of an enclave consists of a fixed measured set of
> pages that are copied to the EPC during the construction process by
> using ENCLS leaf functions and Software Enclave Control Structure (SECS)
> that defines the enclave properties.
> 
> Enclave are constructed by using ENCLS leaf functions ECREATE, EADD and
> EINIT. ECREATE initializes SECS, EADD copies pages from system memory to
> the EPC and EINIT check a given signed measurement and moves the enclave
> into a state ready for execution.
> 
> An initialized enclave can only be accessed through special Thread Control
> Structure (TCS) pages by using ENCLU (ring-3 only) leaf EENTER.  This leaf
> function converts a thread into enclave mode and continues the execution in
> the offset defined by the TCS provided to EENTER. An enclave is exited
> through syscall, exception, interrupts or by explicitly calling another
> ENCLU leaf EEXIT.
> 
> The permissions, which enclave page is added will set the limit for maximum
> permissions that can be set for mmap() and mprotect(). This will
> effectively allow to build different security schemes between producers and
> consumers of enclaves. Later on we can increase granularity with LSM hooks
> for page addition (i.e. for producers) and mapping of the enclave (i.e. for
> consumers)
> 
> Cc: linux-security-module@vger.kernel.org
> Cc: Nathaniel McCallum <npmccallum@redhat.com>
> Co-developed-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Co-developed-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Tested-by: Haitao Huang <haitao.huang@linux.intel.com>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---
>  .../userspace-api/ioctl/ioctl-number.rst      |   1 +
>  arch/x86/include/uapi/asm/sgx.h               |  66 ++
>  arch/x86/kernel/cpu/sgx/Makefile              |   3 +
>  arch/x86/kernel/cpu/sgx/driver.c              | 194 +++++
>  arch/x86/kernel/cpu/sgx/driver.h              |  30 +
>  arch/x86/kernel/cpu/sgx/encl.c                | 329 +++++++++
>  arch/x86/kernel/cpu/sgx/encl.h                |  87 +++
>  arch/x86/kernel/cpu/sgx/ioctl.c               | 697 ++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/main.c                |  12 +-
>  arch/x86/kernel/cpu/sgx/reclaim.c             |   1 +
>  10 files changed, 1419 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/include/uapi/asm/sgx.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/driver.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/driver.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/encl.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/encl.h
>  create mode 100644 arch/x86/kernel/cpu/sgx/ioctl.c
> 
> diff --git a/Documentation/userspace-api/ioctl/ioctl-number.rst b/Documentation/userspace-api/ioctl/ioctl-number.rst
> index 2e91370dc159..1c54dd2704db 100644
> --- a/Documentation/userspace-api/ioctl/ioctl-number.rst
> +++ b/Documentation/userspace-api/ioctl/ioctl-number.rst
> @@ -321,6 +321,7 @@ Code  Seq#    Include File                                           Comments
>                                                                       <mailto:tlewis@mindspring.com>
>  0xA3  90-9F  linux/dtlk.h
>  0xA4  00-1F  uapi/linux/tee.h                                        Generic TEE subsystem
> +0xA4  00-1F  uapi/asm/sgx.h                                          Intel SGX subsystem (a legit conflict as TEE and SGX do not co-exist)
>  0xAA  00-3F  linux/uapi/linux/userfaultfd.h
>  0xAB  00-1F  linux/nbd.h
>  0xAC  00-1F  linux/raw.h
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> new file mode 100644
> index 000000000000..5edb08ab8fd0
> --- /dev/null
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -0,0 +1,66 @@
> +/* SPDX-License-Identifier: (GPL-2.0 OR BSD-3-Clause) WITH Linux-syscall-note */
> +/*
> + * Copyright(c) 2016-19 Intel Corporation.
> + */
> +#ifndef _UAPI_ASM_X86_SGX_H
> +#define _UAPI_ASM_X86_SGX_H
> +
> +#include <linux/types.h>
> +#include <linux/ioctl.h>
> +
> +/**
> + * enum sgx_epage_flags - page control flags
> + * %SGX_PAGE_MEASURE:	Measure the page contents with a sequence of
> + *			ENCLS[EEXTEND] operations.
> + */
> +enum sgx_page_flags {
> +	SGX_PAGE_MEASURE	= 0x01,
> +};
> +
> +#define SGX_MAGIC 0xA4
> +
> +#define SGX_IOC_ENCLAVE_CREATE \
> +	_IOW(SGX_MAGIC, 0x00, struct sgx_enclave_create)
> +#define SGX_IOC_ENCLAVE_ADD_PAGES \
> +	_IOWR(SGX_MAGIC, 0x01, struct sgx_enclave_add_pages)
> +#define SGX_IOC_ENCLAVE_INIT \
> +	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
> +
> +/**
> + * struct sgx_enclave_create - parameter structure for the
> + *                             %SGX_IOC_ENCLAVE_CREATE ioctl
> + * @src:	address for the SECS page data
> + */
> +struct sgx_enclave_create  {
> +	__u64	src;
> +};
> +
> +/**
> + * struct sgx_enclave_add_pages - parameter structure for the
> + *                                %SGX_IOC_ENCLAVE_ADD_PAGE ioctl
> + * @src:	start address for the page data
> + * @offset:	starting page offset
> + * @length:	length of the data (multiple of the page size)
> + * @secinfo:	address for the SECINFO data
> + * @flags:	page control flags
> + * @count:	number of bytes added (multiple of the page size)
> + */
> +struct sgx_enclave_add_pages {
> +	__u64	src;
> +	__u64	offset;
> +	__u64	length;
> +	__u64	secinfo;
> +	__u64	flags;
> +	__u64	count;
> +};

Compared to the last time I looked at the patch set, this API removes the ability to measure individual pages chunks. That is not acceptable.

On 2019-10-11 16:37, Sean Christopherson wrote:
> Hiding the 256-byte granualarity from userspace is a good idea as it's not
> intrinsically tied to the SGX architecture and exists only because of
> latency requirements.

What do you mean by "it's not intrinsically tied to the SGX architecture"? This is a fundamental part of the SGX instruction set. This is the instruction definition from the SDM: "EEXTEND—Extend Uninitialized Enclave Measurement by 256 Bytes".

The exact sequence of EADD/EEXTEND calls is part of the enclave hash. The OS mustn't arbitrarily restrict how an enclave may be loaded. If the enclave loader were to follows OS-specific restrictions, that would result in effectively different enclaves. Because of these interoperability concerns, 256-byte granularity *must* be exposed through the UAPI.

Besides only partially measuring a page, there are some other fringe cases that are technically possible, although I haven't seen any toolchains that do that. These include not interleaving EADD and EEXTEND, not using logical ordering for the EEXTENDs, and call EEXTEND multiple times on the same chunk. Maximum interoperability would require supporting any EADD/EEXTEND sequence.

Maybe we should just add an EEXTEND@offset ioctl? This would give fine-grained control when needed (one could set flags=0 in the add pages ioctl and interleave with EEXTEND as needed). If you're ok adding an EEXTEND ioctl I don't think this issue needs to block landing the driver in its current form, in which case:

Tested-by: Jethro Beekman <jethro@fortanix.com>

Sorry for being super late with this, I know you asked me for feedback about this specific point in October. However, I did previously mention several times that being able to measure individual 256-byte chunks is necessary.

--
Jethro Beekman | Fortanix
