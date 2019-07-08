Return-Path: <SRS0=W/oj=VF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0E22C606C1
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 15:55:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84211216F4
	for <linux-sgx@archiver.kernel.org>; Mon,  8 Jul 2019 15:55:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733025AbfGHPzZ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 8 Jul 2019 11:55:25 -0400
Received: from mga04.intel.com ([192.55.52.120]:60243 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731637AbfGHPzZ (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 8 Jul 2019 11:55:25 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jul 2019 08:55:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,466,1557212400"; 
   d="scan'208";a="159161155"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga008.jf.intel.com with ESMTP; 08 Jul 2019 08:55:24 -0700
Date:   Mon, 8 Jul 2019 08:55:24 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Cedric Xing <cedric.xing@intel.com>
Cc:     linux-sgx@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, casey.schaufler@intel.com,
        jmorris@namei.org, luto@kernel.org, jethro@fortanix.com,
        greg@enjellic.com, sds@tycho.nsa.gov,
        jarkko.sakkinen@linux.intel.com
Subject: Re: [RFC PATCH v3 0/4] security/x86/sgx: SGX specific LSM hooks
Message-ID: <20190708155524.GD20433@linux.intel.com>
References: <cover.1561588012.git.cedric.xing@intel.com>
 <cover.1562542383.git.cedric.xing@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1562542383.git.cedric.xing@intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Jul 07, 2019 at 04:41:30PM -0700, Cedric Xing wrote:
...

> different FSMs to govern page protection transitions. Implementation wise, his
> model also imposes unwanted restrictions specifically to SGX2, such as:
>   · Complicated/Restricted UAPI – Enclave loaders are required to provide

I don't think "complicated" is a fair assessment.  For SGX1 enclaves it's
literally a direct propagation of the SECINFO RWX flags.

>     “maximal protection” at page load time, but such information is NOT always
>     available. For example, Graphene containers may run different applications
>     comprised of different set of executables and/or shared objects. Some of
>     them may contain self-modifying code (or text relocation) while others
>     don’t. The generic enclave loader usually doesn’t have such information so
>     wouldn’t be able to provide it ahead of time.

I'm unconvinced that it would be remotely difficult to teach an enclave
loader that an enclave or hosted application employs SMC, relocation or
any other behavior that would require declaring RWX on all pages.

>   · Inefficient Auditing – Audit logs are supposed to help system
>     administrators to determine the set of minimally needed permissions and to
>     detect abnormal behaviors. But consider the “maximal protection” model, if
>     “maximal protection” is set to be too permissive, then audit log wouldn’t
>     be able to detect anomalies;

Huh?  Declaring overly permissive protections is only problematic if an
LSM denies the permission, in which case it will generate an accurate
audit log.

If the enclave/loader "requires" a permission it doesn't actually need,
e.g. EXECDIRTY, then it's a software bug that should be fixed.  I don't
see how this scenario is any different than an application that uses
assembly code without 'noexecstack' and inadvertantly "requires"
EXECSTACK due to triggering "read implies exec".  In both cases the
denied permission is unnecessary due to a userspace application bug.

>     or if “maximal protection” is too restrictive,
>     then audit log cannot identify the file violating the policy.

Maximal protections that are too restrictive are completely orthogonal to
LSMs as the enclave would fail to run irrespective of LSMs.  This is no
different than specifying the wrong RWX flags in SECINFO, or opening a
file as RO instead of RW.

> In either case the audit log cannot fulfill its purposes.
>   · Inability to support #PF driven EPC allocation in SGX2 – For those
>     unfamiliar with SGX2 software flows, an SGX2 enclave requests a page by
>     issuing EACCEPT on the address that a new page is wanted, and the resulted
>     #PF is expected to be handled by the kernel by EAUG’ing an EPC page at the
>     fault address, and then the enclave would be resumed and the faulting
>     EACCEPT retried, and succeed. The key requirement is to allow mmap()’ing
>     non-existing enclave pages so that the SGX module/subsystem could respond
>     to #PFs by EAUG’ing new pages. Sean’s implementation doesn’t allow
>     mmap()’ing non-existing pages for variety of reasons and therefore blocks
>     this major SGX2 usage.

This is simply wrong.  The key requirement in the theoretical EAUG scheme
is to mmap() pages that have not been added to the _hardware_ maintained
enclave.  The pages (or some optimized representation of a range of pages)
would exist in the kernel's software mode of the enclave.
