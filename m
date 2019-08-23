Return-Path: <SRS0=JCck=WT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C30C3A5A2
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 16:27:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F2C822CEC
	for <linux-sgx@archiver.kernel.org>; Fri, 23 Aug 2019 16:27:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388596AbfHWQ1k (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 23 Aug 2019 12:27:40 -0400
Received: from mga04.intel.com ([192.55.52.120]:2253 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732570AbfHWQ1k (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 23 Aug 2019 12:27:40 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Aug 2019 09:27:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,422,1559545200"; 
   d="scan'208";a="263234292"
Received: from unknown (HELO localhost) ([10.252.39.229])
  by orsmga001.jf.intel.com with ESMTP; 23 Aug 2019 09:27:36 -0700
Date:   Fri, 23 Aug 2019 19:27:35 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     sean.j.christopherson@intel.com
Cc:     luto@kernel.org, linux-sgx@vger.kernel.org, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com
Subject: Re: sgx_encl_may_map()
Message-ID: <20190823162705.xhpk4nhx7rzzq636@linux.intel.com>
References: <20190823150248.kuxgdxyd4z5wlsz5@linux.intel.com>
 <20190823160404.oszonu4srjx276a3@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823160404.oszonu4srjx276a3@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Aug 23, 2019 at 07:04:04PM +0300, Jarkko Sakkinen wrote:
> On Fri, Aug 23, 2019 at 06:02:48PM +0300, Jarkko Sakkinen wrote:
> > 3. Why don't just store SECINFO flags on EADD? Doing
> >    calc_vma_prot_bits() on fly is not expensive. Now
> >    data in SECINFO flags is scattered to two different
> >    fields (desc and vm_max_prot_bits). I'd just have a field
> >    called secinfo_flags.
> 
> Makes sense to have that field as a cache so that we don't have to do
> recalc per page in the sgx_encl_may_map() and thus makes sense to keep
> TCS tagging in desc.

(1) and (2) I will remark in v22 patch review. It is better to do that
way.

I squashed my remaining fixes that I just posted to the patch set.

The final change log for v22 is:

* Alignment checks have been removed from mmap() because it does not define the
  ELRANGE. VMAs only act as windows to the enclave. The semantics compare
  somewhat how mmap() works with regular files.
* We now require user space addresses given to SGX_IOC_ENCLAVE_ADD_PAGE to be
  page aligned so that we can pass the page directly to EADD and do not have
  to do an extra copy. This was made effectively possible by removing the
  worker thread for adding pages.
* The selftest build files have been refined throughout of various glitches
  and work properly in a cross compilation environment such as BuildRoot.
  In addition, libcalls fail the build with an assertion in the linker
  script, if they end up to the enclave binary.
* CONFIG_INTEL_SGX_DRIVER has been removed because you cannot use SGX core
  for anything without having the driver. This could change when KVM support
  is added.
* We require zero permissions in SECINFO for TCS pages because the CPU
  overwrites SECINFO flags with zero permissions and measures the page
  only after that. Allowing to pass TCS with non-zero permissions would
  cause mismatching measurement between the one provided in SIGSTRUCT and
  the one computed by the CPU.

As I noted I can ATM run only selftest as the stress test that I'm using
is not yet working with the latets API changes.

Can you give it a shot?

/Jarkko
