Return-Path: <SRS0=CuW6=XW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A419C4360C
	for <linux-sgx@archiver.kernel.org>; Fri, 27 Sep 2019 16:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FFBA217D9
	for <linux-sgx@archiver.kernel.org>; Fri, 27 Sep 2019 16:12:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727349AbfI0QME (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 27 Sep 2019 12:12:04 -0400
Received: from mga01.intel.com ([192.55.52.88]:32610 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727273AbfI0QME (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 27 Sep 2019 12:12:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2019 09:11:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,556,1559545200"; 
   d="scan'208";a="184028854"
Received: from mdauner2-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.39.118])
  by orsmga008.jf.intel.com with ESMTP; 27 Sep 2019 09:11:47 -0700
Date:   Fri, 27 Sep 2019 19:11:45 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        Kai Huang <kai.huang@linux.intel.com>,
        Haim Cohen <haim.cohen@intel.com>
Subject: Re: [PATCH v22 02/24] x86/cpufeatures: x86/msr: Intel SGX Launch
 Control hardware bits
Message-ID: <20190927161145.GM10545@linux.intel.com>
References: <20190903142655.21943-1-jarkko.sakkinen@linux.intel.com>
 <20190903142655.21943-3-jarkko.sakkinen@linux.intel.com>
 <20190924155232.GG19317@zn.tnic>
 <20190924202210.GC16218@linux.intel.com>
 <20190925085156.GA3891@zn.tnic>
 <20190925171824.GF31852@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190925171824.GF31852@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Sep 25, 2019 at 10:18:24AM -0700, Sean Christopherson wrote:
> > I wouldn't be too surprised if this happened. BIOS is very inventive.
> 
> Given the number of steps BIOS needs to take to enable SGX, that'd be one
> "inventive" BIOS. :-)
> 
> Anyways, adding logic to opportunistically set FEATURE_CONTROL during boot
> should be trivial.  I'll prep a patch and send it separately from the SGX
> series, moving the existing KVM code would be a good change irrespective
> of SGX.

Also, based on Borislav's remarks, the commit message should be more
clear about launch control (separately describe the driver and KVM
use). I can rework that.

/Jarkko
