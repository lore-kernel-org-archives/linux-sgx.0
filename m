Return-Path: <SRS0=Np89=7O=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FE9FC433DF
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jun 2020 00:50:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7D062067B
	for <linux-sgx@archiver.kernel.org>; Mon,  1 Jun 2020 00:50:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728390AbgFAAuz (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 31 May 2020 20:50:55 -0400
Received: from mga03.intel.com ([134.134.136.65]:64612 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727915AbgFAAuz (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 31 May 2020 20:50:55 -0400
IronPort-SDR: J60nNyseau5tf21gUM0TPfx0fVBfmCD9peg73fjSzmYL7J0O+TgQvfp8d7/zKhSqqhpsXq5Y+Y
 GllNM2ydRaog==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2020 17:50:54 -0700
IronPort-SDR: Q/gIHQkG8X5m0Q/PWM6E4w/0Len0NbZu4KS8xNT3YSOsBIRRSJGDSlfrXub/cJB7npi1LgSatK
 Y1tChwxQaRbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,458,1583222400"; 
   d="scan'208";a="311804445"
Received: from hbetts-mobl.ger.corp.intel.com (HELO localhost) ([10.252.59.178])
  by FMSMGA003.fm.intel.com with ESMTP; 31 May 2020 17:50:53 -0700
Date:   Mon, 1 Jun 2020 03:50:51 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v31 3/6] x86/sgx: Rename sgx_free_page() to
 sgx_free_epc_page()
Message-ID: <20200601005051.GA660229@linux.intel.com>
References: <20200529175407.2109-1-sean.j.christopherson@intel.com>
 <20200529175407.2109-4-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200529175407.2109-4-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 29, 2020 at 10:54:04AM -0700, Sean Christopherson wrote:
> Add "epc" into the free page helper to match sgx_alloc_epc_page().
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Would be better if you find something like this you just send patch
against the commit that introduces the symbol. That way the patch would
have at least some utilitary use.

/Jarkko
