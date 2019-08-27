Return-Path: <SRS0=8+LH=WX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F68C3A5A3
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 12:26:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D19E206BA
	for <linux-sgx@archiver.kernel.org>; Tue, 27 Aug 2019 12:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbfH0M0C (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 27 Aug 2019 08:26:02 -0400
Received: from mga06.intel.com ([134.134.136.31]:12641 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726170AbfH0M0C (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 27 Aug 2019 08:26:02 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 05:25:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="180211836"
Received: from jsakkine-mobl1.fi.intel.com (HELO localhost) ([10.237.66.169])
  by fmsmga008.fm.intel.com with ESMTP; 27 Aug 2019 05:25:56 -0700
Date:   Tue, 27 Aug 2019 15:25:55 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH 2/4] x86/sgx: Preserved allowed attributes during
 SGX_IOC_ENCLAVE_CREATE
Message-ID: <20190827122555.g73tp26v5yr5jbhl@linux.intel.com>
References: <20190827001128.25066-1-sean.j.christopherson@intel.com>
 <20190827001128.25066-3-sean.j.christopherson@intel.com>
 <20190827121201.i4yy57ixwzcfl3v4@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827121201.i4yy57ixwzcfl3v4@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Aug 27, 2019 at 03:12:01PM +0300, Jarkko Sakkinen wrote:
> On Mon, Aug 26, 2019 at 05:11:26PM -0700, Sean Christopherson wrote:
> > Preserve any existing attributes set via ENCLAVE_SET_ATTRIBUTE when
> > setting the always allowed attributes during ENCLAVE_CREATE.  There is
> > no requirement that ENCLAVE_SET_ATTRIBUTE can only be called after the
> > enclave is created.
> > 
> > Note, this does not fix a race condition between ENCLAVE_CREATE and
> > ENCLAVE_SET_ATTRIBUTE, as the latter doesn't take encl->lock.  This will
> > be addressed in a future patch.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Acked-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

This now merged to my tree.

/Jarkko
