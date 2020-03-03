Return-Path: <SRS0=VHel=4U=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C136C3F2CD
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Mar 2020 00:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78242217F4
	for <linux-sgx@archiver.kernel.org>; Tue,  3 Mar 2020 00:39:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgCCAje (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 2 Mar 2020 19:39:34 -0500
Received: from mga12.intel.com ([192.55.52.136]:60888 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726752AbgCCAje (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 2 Mar 2020 19:39:34 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Mar 2020 16:39:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,509,1574150400"; 
   d="scan'208";a="351688462"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.202])
  by fmsmga001.fm.intel.com with ESMTP; 02 Mar 2020 16:39:32 -0800
Date:   Mon, 2 Mar 2020 16:39:32 -0800
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com
Subject: Re: [PATCH v27 04/22] x86/sgx: Add SGX microarchitectural data
 structures
Message-ID: <20200303003932.GA27842@linux.intel.com>
References: <20200223172559.6912-1-jarkko.sakkinen@linux.intel.com>
 <20200223172559.6912-5-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200223172559.6912-5-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sun, Feb 23, 2020 at 07:25:41PM +0200, Jarkko Sakkinen wrote:
> Define the SGX microarchitectural data structures used by various SGX
> opcodes. This is not an exhaustive representation of all SGX data
> structures but only those needed by the kernel.
> 
> The data structures are described in:
> 
>   Intel SDM: 37.6 INTEL® SGX DATA STRUCTURES OVERVIEW
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> ---

...

> +#define SGX_SSA_GPRS_SIZE		182

SSA GPRs size is 184.  Per table 37.9 in the SDM:

  Field    OFFSET (Bytes)    Size (Bytes)

  GSBASE   176               8

Reported by a third party, I'm just the messenger and not that good at math :-).
