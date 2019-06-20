Return-Path: <SRS0=1VuV=UT=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BAF6C43613
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 19:23:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AFB02082C
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Jun 2019 19:23:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbfFTTXo (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Jun 2019 15:23:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:31207 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725993AbfFTTXo (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Jun 2019 15:23:44 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Jun 2019 12:23:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,397,1557212400"; 
   d="scan'208";a="165432705"
Received: from mudigirx-mobl1.gar.corp.intel.com (HELO localhost) ([10.252.61.12])
  by orsmga006.jf.intel.com with ESMTP; 20 Jun 2019 12:23:42 -0700
Date:   Thu, 20 Jun 2019 22:23:40 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org
Subject: Re: [PATCH] x86/sgx: rip off the refcount from sgx_encl_add_page flow
Message-ID: <20190620192340.GB15383@linux.intel.com>
References: <20190619122143.12028-1-jarkko.sakkinen@linux.intel.com>
 <20190619154341.GF1203@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190619154341.GF1203@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 19, 2019 at 08:43:41AM -0700, Sean Christopherson wrote:
> We should set SGX_ENCL_DEAD before flush_work().  Other than that I can't
> think of any issues with this approach.  Though hopefully we can purge the
> worker altogether and make it a moot point :-).

Thanks, I squashed the change now. And definitely we can considere to
completely purge that. This change probably won't make it more
difficult :-)

I also removed PM notifier and SGX_ENCL_SUSPEND. Did not bother to cycle
that change here because on that we've already made conclusions. Just
have forgot to do that change.

/Jarkko
