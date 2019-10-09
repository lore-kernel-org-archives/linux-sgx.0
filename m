Return-Path: <SRS0=7vij=YC=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE837C4360C
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 00:04:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8CE7F20873
	for <linux-sgx@archiver.kernel.org>; Wed,  9 Oct 2019 00:04:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729700AbfJIAEx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 8 Oct 2019 20:04:53 -0400
Received: from mga14.intel.com ([192.55.52.115]:44761 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728271AbfJIAEx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 8 Oct 2019 20:04:53 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 17:04:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="223404192"
Received: from jhogan1-mobl.ger.corp.intel.com (HELO localhost) ([10.252.2.221])
  by fmsmga002.fm.intel.com with ESMTP; 08 Oct 2019 17:04:51 -0700
Date:   Wed, 9 Oct 2019 03:04:50 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: WARN once if EREMOVE fails when killing an
 enclave
Message-ID: <20191009000450.GA14261@linux.intel.com>
References: <20191008041334.3235-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191008041334.3235-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Oct 07, 2019 at 09:13:34PM -0700, Sean Christopherson wrote:
> WARN if EREMOVE fails when destroying an enclave.  sgx_encl_release()
> uses the non-WARN __sgx_free_page() when freeing pages as some pages may
> be in the process of being reclaimed, i.e. are owned by the reclaimer.
> But EREMOVE should never fail as sgx_encl_destroy() is only called when
> the enclave cannot have active threads, e.g. prior to EINIT and when the
> enclave is being released.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

For me this concludes that I will manually convert all the call sites
to use __sgx_free_page() and add appropriate warnings. I agree with
Borislav's conclusions here.

/Jarkko
