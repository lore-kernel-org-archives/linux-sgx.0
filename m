Return-Path: <SRS0=yHMC=WF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF775C433FF
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Aug 2019 21:21:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA11B2089E
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Aug 2019 21:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfHIVV6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 9 Aug 2019 17:21:58 -0400
Received: from mga05.intel.com ([192.55.52.43]:16994 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbfHIVV6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 9 Aug 2019 17:21:58 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Aug 2019 14:21:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,366,1559545200"; 
   d="scan'208";a="175264188"
Received: from wulili-mobl1.ger.corp.intel.com (HELO localhost) ([10.249.36.9])
  by fmsmga008.fm.intel.com with ESMTP; 09 Aug 2019 14:21:56 -0700
Date:   Sat, 10 Aug 2019 00:21:55 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Subject: Re: [PATCH for_v22 06/11] x86/sgx: Check the bounds of the enclave
 address against ELRANGE
Message-ID: <20190809212155.c6jpjuzevaehreib@linux.intel.com>
References: <20190808001254.11926-1-sean.j.christopherson@intel.com>
 <20190808001254.11926-7-sean.j.christopherson@intel.com>
 <20190808154530.syoumkpdsgcdpyot@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190808154530.syoumkpdsgcdpyot@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Aug 08, 2019 at 06:45:30PM +0300, Jarkko Sakkinen wrote:
> On Wed, Aug 07, 2019 at 05:12:49PM -0700, Sean Christopherson wrote:
> > Reject EADD if the destination address lies outside the bounds of the
> > enclave's ELRANGE as tracked by encl->base and encl->size.  Lack of a
> > check allows userspace to induce a #GP on EADD.
> > 
> > Reported-by: Shay Katz-zamir <shay.katz-zamir@intel.com>
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Applied with "patch -p1 -u" as my earlier merges screwed the ancestors.
Merged and pushed.

/Jarkko
