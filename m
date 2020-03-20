Return-Path: <SRS0=dBTT=5F=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0082C4332D
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 02:39:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1078206D7
	for <linux-sgx@archiver.kernel.org>; Fri, 20 Mar 2020 02:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgCTCjv (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 19 Mar 2020 22:39:51 -0400
Received: from mga14.intel.com ([192.55.52.115]:30297 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgCTCjv (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 19 Mar 2020 22:39:51 -0400
IronPort-SDR: GiXxJUk4QYmRc/wdoRU8dzWCA4Wk4dzwE2cny/6bknDU3jj2xX5EKDbvjeYFFuLRf+73G9RzUU
 E8TszwQUD7sw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2020 19:39:51 -0700
IronPort-SDR: 2qEb3B8Pr+ZDDysUkwmsU4hKBw87zSQmrFV7amPyQCc+j+sC66PlxsprlDKAIJ1sChGvFJmQAE
 U3i+I+s9A0yA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,283,1580803200"; 
   d="scan'208";a="444814817"
Received: from anakash-mobl2.ger.corp.intel.com (HELO localhost) ([10.251.183.74])
  by fmsmga005.fm.intel.com with ESMTP; 19 Mar 2020 19:39:48 -0700
Date:   Fri, 20 Mar 2020 04:39:47 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [PATCH for_v29 2/8] x86/sgx: vdso: Make the %rsp fixup on return
 from handler relative
Message-ID: <20200320023947.GD183331@linux.intel.com>
References: <20200319011130.8556-1-sean.j.christopherson@intel.com>
 <20200319011130.8556-3-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319011130.8556-3-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Mar 18, 2020 at 06:11:24PM -0700, Sean Christopherson wrote:
> Modify the %rsp fixup after returning from the exit handler to be
> relative instead of absolute to avoid clobbering any %rsp adjustments
> made by the exit handler, e.g. if the exit handler modifies the stack
> prior to re-entering the enclave.
> 
> Reported-by: Nathaniel McCallum <npmccallum@redhat.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> I'm on the fence as to whether or not this is a good idea.  It's not super
> painful, but it's not exactly standard/obvious code.  Part of me thinks
> its a bug to not let the exit handler manipulate %rsp, the other part of
> me thinks it's straight up crazy :-)

After some hours of processing this, I think this makes sense.

It makes the interface more robust. This is not printf().

/Jarkko
