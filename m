Return-Path: <SRS0=BSu2=CF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C95AC433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Aug 2020 13:36:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 825C9207CD
	for <linux-sgx@archiver.kernel.org>; Thu, 27 Aug 2020 13:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726393AbgH0NgX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 27 Aug 2020 09:36:23 -0400
Received: from mga01.intel.com ([192.55.52.88]:11396 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727957AbgH0Nfi (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 27 Aug 2020 09:35:38 -0400
IronPort-SDR: /N7uiuzDqHVtTPkPpkQNldVkmm7w2+7DQTJB6RNeZt61zLnsuB8aPrPZyChqV+Afu6glaC0zm8
 zr1dghh/LlXw==
X-IronPort-AV: E=McAfee;i="6000,8403,9725"; a="174527363"
X-IronPort-AV: E=Sophos;i="5.76,359,1592895600"; 
   d="scan'208";a="174527363"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Aug 2020 06:35:28 -0700
IronPort-SDR: lu6728k2wBkh83MfCptz+gl98ByCVLI9Cu/eytjf+3dZKyGos0cI0TWPfgva4ibIv51rteEoL3
 M5Qfx8jvxjTA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,359,1592895600"; 
   d="scan'208";a="403402491"
Received: from tbeaumon-mobl3.ger.corp.intel.com (HELO localhost) ([10.252.55.254])
  by fmsmga001.fm.intel.com with ESMTP; 27 Aug 2020 06:35:25 -0700
Date:   Thu, 27 Aug 2020 16:35:24 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Nathaniel McCallum <npmccallum@redhat.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-sgx@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] x86/vdso: x86/sgx: Rework
 __vdso_sgx_enter_enclave() API
Message-ID: <20200827133524.GC4674@linux.intel.com>
References: <20200818042405.12871-1-sean.j.christopherson@intel.com>
 <20200818042405.12871-3-sean.j.christopherson@intel.com>
 <20200826202029.GD21459@sjchrist-ice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200826202029.GD21459@sjchrist-ice>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 26, 2020 at 01:20:29PM -0700, Sean Christopherson wrote:
> Andy,
> 
> Any thoughts on using a struct versus a plethora of params?  If you don't
> have a strong opinion, I'd like to push for the struct option as it fixes
> the -EFAULT weirdness, satisfies Nathaniel's request, and gives some
> flexibility for the future.  The code impact, both to the vDSO and to the
> caller, is largely a lateral move, i.e. it's different but in the end
> doesn't require any more or less work.

If we ended up ever considering eBPF idea that I throwed a while ago in
the air, most likely the same struct could be use as the context for the
BPF program and larger portion of the existing vDSO code would remain
intact.

I'm not trying gonzo market BPF.

I'm just pointing out that a struct is a great vessel to travel between
kernel and user space (e.g. a BPF program would be executed by the
kernel by using the vDSO provided context struct).

/Jarkko
