Return-Path: <SRS0=Qwf+=N3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF762C43441
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Nov 2018 15:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77779208E7
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Nov 2018 15:14:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 77779208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbeKQB0t (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 16 Nov 2018 20:26:49 -0500
Received: from mga06.intel.com ([134.134.136.31]:48029 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728079AbeKQB0t (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 16 Nov 2018 20:26:49 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Nov 2018 07:14:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,240,1539673200"; 
   d="scan'208";a="250282462"
Received: from sfhansen-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.254.82])
  by orsmga004.jf.intel.com with ESMTP; 16 Nov 2018 07:13:52 -0800
Date:   Fri, 16 Nov 2018 17:13:51 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@linux.intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, mark.shanahan@intel.com, luto@amacapital.net,
        Kai Huang <kai.huang@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 02/23] x86/cpufeatures: Add Intel-defined SGX feature
 bit
Message-ID: <20181116151351.GB4244@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-3-jarkko.sakkinen@linux.intel.com>
 <20181116142840.GI20313@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116142840.GI20313@zn.tnic>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 16, 2018 at 03:28:40PM +0100, Borislav Petkov wrote:
> Reviewed-by: Borislav Petkov <bp@suse.de>

Thank you, the very first reviewed-by 8-)

/Jarkko
