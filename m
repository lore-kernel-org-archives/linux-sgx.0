Return-Path: <SRS0=8iz8=RZ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C05C43381
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Mar 2019 11:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6CA4A2082C
	for <linux-sgx@archiver.kernel.org>; Fri, 22 Mar 2019 11:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbfCVLKw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 22 Mar 2019 07:10:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:58512 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728011AbfCVLKw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 22 Mar 2019 07:10:52 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Mar 2019 04:10:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,256,1549958400"; 
   d="scan'208";a="329681949"
Received: from vanderss-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.254.199])
  by fmsmga006.fm.intel.com with ESMTP; 22 Mar 2019 04:10:43 -0700
Date:   Fri, 22 Mar 2019 13:10:41 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v19 16/27] x86/sgx: Add the Linux SGX Enclave Driver
Message-ID: <20190322111041.GG3122@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-17-jarkko.sakkinen@linux.intel.com>
 <20190319211951.GI25575@linux.intel.com>
 <20190321155111.GR4603@linux.intel.com>
 <20190321164714.GE6519@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321164714.GE6519@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Mar 21, 2019 at 09:47:14AM -0700, Sean Christopherson wrote:
> Hotplugging what?  EPC can't be hotplugged, EPC enumeration through CPUID
> won't change post-boot and the ACPI entry can't be relied upon for EPC
> base/size information when there are multiple EPC sections.

AFAIK still there should be no multiple entries with the same id.

> What if we clear vm_private_data?  And maybe do a pr_warn_ratelimited()
> so that userspace gets some form of notification that forking an enclave
> failed.  A NULL encl is easy to check in the fault handler and any where
> else we consume vmas.

That might work.

> Ah, I see the flow.  If we do keep the enclave killing behavior then I
> think it'd make sense to let this be handled by checking SGX_ENCL_DEAD.
> But AFAICT things will "just work" if we nullify vm_private_data.

Yeah so I would refine this by nullifying vm_private_data as you
suggested. This will keep other processes alive having the enclave.
#PF handler shoud check that and SIGBUS.

/Jarkko
