Return-Path: <SRS0=XAjE=NR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0537BC32789
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 05:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C28A72085B
	for <linux-sgx@archiver.kernel.org>; Tue,  6 Nov 2018 05:49:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C28A72085B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729342AbeKFPMx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 6 Nov 2018 10:12:53 -0500
Received: from mga12.intel.com ([192.55.52.136]:6015 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729319AbeKFPMx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 6 Nov 2018 10:12:53 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Nov 2018 21:49:22 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,470,1534834800"; 
   d="scan'208";a="271694568"
Received: from unknown (HELO localhost) ([10.249.254.149])
  by orsmga005.jf.intel.com with ESMTP; 05 Nov 2018 21:49:13 -0800
Date:   Tue, 6 Nov 2018 07:49:11 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@intel.com,
        mark.shanahan@intel.com, andriy.shevchenko@linux.intel.com,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v15 23/23] x86/sgx: Driver documentation
Message-ID: <20181106054911.GA15575@linux.intel.com>
References: <20181102231320.29164-1-jarkko.sakkinen@linux.intel.com>
 <20181102231320.29164-24-jarkko.sakkinen@linux.intel.com>
 <154ded23-fd1d-f324-4e0a-9de8eddcda6d@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <154ded23-fd1d-f324-4e0a-9de8eddcda6d@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org
Message-ID: <20181106054911.prAiEDNEQAK8lZyE5JBM_mAudBgwiVkEbEV6gCfNEAc@z>

On Mon, Nov 05, 2018 at 12:27:11PM -0800, Dave Hansen wrote:
> The ABI seems entirely undocumented and rather lightly designed, which
> seems like something we should fix before this is merged.

ABI is documented in arch/x86/include/uapi/asm/sgx.h that from which the
documentation is included to intel_sgx.rst. I'm not saying that there is
no space refine it but it is neither undocumented.

> Also, for a feature as massive and complicated as this one, it seems
> irresponsible to not have a selftest.  Is that not feasible for some reason?

I do have the in-kernel launch enclave stuff backed up here:

https://github.com/jsakkine-intel/sgx-le-host
https://github.com/jsakkine-intel/sgx-le

This is about as simple as it gets without any type of run-time.

/Jarkko
