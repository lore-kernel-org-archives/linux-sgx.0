Return-Path: <SRS0=Uuw6=4I=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 779ECC11D00
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Feb 2020 22:16:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C3DC20801
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Feb 2020 22:16:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727778AbgBTWQU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Feb 2020 17:16:20 -0500
Received: from mga12.intel.com ([192.55.52.136]:20659 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727656AbgBTWQT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Feb 2020 17:16:19 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2020 14:16:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,465,1574150400"; 
   d="scan'208";a="240154208"
Received: from evieschw-mobl.ger.corp.intel.com (HELO localhost) ([10.251.86.197])
  by orsmga006.jf.intel.com with ESMTP; 20 Feb 2020 14:16:08 -0800
Date:   Fri, 21 Feb 2020 00:16:07 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Jordan Hand <jorhand@linux.microsoft.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v26 10/22] x86/sgx: Linux Enclave Driver
Message-ID: <20200220221607.GB26618@linux.intel.com>
References: <20200209212609.7928-1-jarkko.sakkinen@linux.intel.com>
 <20200209212609.7928-11-jarkko.sakkinen@linux.intel.com>
 <15074c16-4832-456d-dd12-af8548e46d6d@linux.microsoft.com>
 <20200220181345.GD3972@linux.intel.com>
 <7738b3cf-fb32-5306-5740-59974444e327@linux.microsoft.com>
 <20200220184842.GE3972@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220184842.GE3972@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Feb 20, 2020 at 10:48:42AM -0800, Sean Christopherson wrote:
> My biggest concern for allowing PROT_EXEC if RIE is that it would result
> in #PF(SGX) (#GP on Skylake) due to an EPCM violation if the enclave
> actually tried to execute from such a page.  This isn't a problem for the
> kernel as the fault will be reported cleanly through the vDSO (or get
> delivered as a SIGSEGV if the enclave isn't entered through the vDSO), but
> it's a bit weird for userspace as userspace will see the #PF(SGX) and
> likely assume the EPC was lost, e.g. silently restart the enclave instead
> of logging an error that the enclave is broken.

I think right way to fix the current implementation is to -EACCES mmap()
(and mprotect) when !!(current->personality & READ_IMPLIES_EXEC).

This way supporting RIE can be reconsidered later on without any
potential ABI bottlenecks.

/Jarkko
