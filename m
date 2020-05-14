Return-Path: <SRS0=4/gY=64=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84444C433DF
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 16:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67A7220675
	for <linux-sgx@archiver.kernel.org>; Thu, 14 May 2020 16:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgENQQB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 14 May 2020 12:16:01 -0400
Received: from mga06.intel.com ([134.134.136.31]:47271 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbgENQQA (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 14 May 2020 12:16:00 -0400
IronPort-SDR: Rv5SbDg54T7mKaNTGDo55y+40Z8dFHOXPzgM9yE004zB4Fzbh25EBYxYwyUyk9lgNWxmCc9BAQ
 i22EHzHHsf/g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 09:16:00 -0700
IronPort-SDR: VEUTrlChGIZsTXXvAg7bA39pEQpzc9TVeV2C+0RdmxvXui37N5FZYOVkZXxrrKWZMSdjV1lwtP
 dQVSwDwazCaw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,392,1583222400"; 
   d="scan'208";a="464394342"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga005.fm.intel.com with ESMTP; 14 May 2020 09:15:59 -0700
Date:   Thu, 14 May 2020 09:15:59 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, kai.svahn@intel.com,
        bp@alien8.de, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        puiterwijk@redhat.com
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
Message-ID: <20200514161559.GA15603@linux.intel.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
 <20200426165753.GA11046@wind.enjellic.com>
 <87d07gk24l.fsf@nanos.tec.linutronix.de>
 <20200508190226.GA31465@wind.enjellic.com>
 <20200508195635.GR27052@linux.intel.com>
 <20200514091637.GA25156@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514091637.GA25156@wind.enjellic.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 14, 2020 at 04:16:37AM -0500, Dr. Greg wrote:
> What we would recommend at this point is that you and Jarkko do the
> Linux community and beyond a favor and wire up a simple kernel
> command-line parameter that controls the ability of the driver to be
> used, ie. enables/disables access to /dev/sgx/enclave.

I'm not opposed to adding a kernel param to disable SGX.  At one point
there was a proposal to extend clearcpuid to allow disabling multiple
feature bits, but it looks like that went the way of the dodo.

Note, such a param would disable SGX entirely, e.g. clear the feature bit
in /proc/cpuinfo and prevent any in-kernel SGX code from running.
