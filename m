Return-Path: <SRS0=OFrI=N5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 233E8C43441
	for <linux-sgx@archiver.kernel.org>; Sun, 18 Nov 2018 08:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6A512075B
	for <linux-sgx@archiver.kernel.org>; Sun, 18 Nov 2018 08:36:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D6A512075B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbeKRS4W (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 18 Nov 2018 13:56:22 -0500
Received: from mga04.intel.com ([192.55.52.120]:15771 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbeKRS4W (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 18 Nov 2018 13:56:22 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Nov 2018 00:36:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,247,1539673200"; 
   d="scan'208";a="107227262"
Received: from kaczmarx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.89])
  by fmsmga004.fm.intel.com with ESMTP; 18 Nov 2018 00:36:37 -0800
Date:   Sun, 18 Nov 2018 10:36:33 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@linux.intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, mark.shanahan@intel.com, luto@amacapital.net,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 03/23] x86/cpufeatures: Add SGX sub-features (as
 Linux-defined bits)
Message-ID: <20181118083633.GL5897@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-4-jarkko.sakkinen@linux.intel.com>
 <1b326c2a-eec9-3a8b-1dff-81c596b2ac44@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1b326c2a-eec9-3a8b-1dff-81c596b2ac44@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 16, 2018 at 03:31:28PM -0800, Dave Hansen wrote:
> On 11/15/18 5:01 PM, Jarkko Sakkinen wrote:
> > +#define X86_FEATURE_SGX1		( 8*32+ 0) /* SGX1 leaf functions */
> > +#define X86_FEATURE_SGX2		( 8*32+ 1) /* SGX2 leaf functions */
> 
> Is there a reason these are not (all) tied to CONFIG_INTEL_SGX via:
> 
> arch/x86/include/asm/disabled-features.h
> 
> ?

No any particular reason.

/Jarkko
