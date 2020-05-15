Return-Path: <SRS0=5ZAu=65=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A28DDC433DF
	for <linux-sgx@archiver.kernel.org>; Fri, 15 May 2020 00:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C8382065C
	for <linux-sgx@archiver.kernel.org>; Fri, 15 May 2020 00:10:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728111AbgEOAKG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 14 May 2020 20:10:06 -0400
Received: from mga04.intel.com ([192.55.52.120]:42206 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726126AbgEOAKG (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 14 May 2020 20:10:06 -0400
IronPort-SDR: pkFGblMOY2j5yiA/yZ/jcIlrNohbII0GJ6I/t+j48+JmT+3SXUqEEEvMbDrKsm76cHsikhD8sC
 BG1I0BodLrbQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2020 17:10:05 -0700
IronPort-SDR: ZuELA/pasdQHWdIMcniaCT/O4dTde3mW3ly2mv7op4BtG1un9Dm5SayHJcCOa1nfm9mpr7tvoj
 ha6pX6mLNVzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,392,1583222400"; 
   d="scan'208";a="266423735"
Received: from ashadrin-mobl1.ccr.corp.intel.com ([10.249.38.112])
  by orsmga006.jf.intel.com with ESMTP; 14 May 2020 17:09:55 -0700
Message-ID: <fa1465e6fc3e8f40330673b28137e92755bf1fa7.camel@linux.intel.com>
Subject: Re: [PATCH v29 00/20] Intel SGX foundations
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr. Greg" <greg@enjellic.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        akpm@linux-foundation.org, dave.hansen@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, kai.svahn@intel.com,
        bp@alien8.de, josh@joshtriplett.org, luto@kernel.org,
        kai.huang@intel.com, rientjes@google.com, cedric.xing@intel.com,
        puiterwijk@redhat.com
Date:   Fri, 15 May 2020 03:09:42 +0300
In-Reply-To: <20200514161559.GA15603@linux.intel.com>
References: <20200421215316.56503-1-jarkko.sakkinen@linux.intel.com>
         <20200426165753.GA11046@wind.enjellic.com>
         <87d07gk24l.fsf@nanos.tec.linutronix.de>
         <20200508190226.GA31465@wind.enjellic.com>
         <20200508195635.GR27052@linux.intel.com>
         <20200514091637.GA25156@wind.enjellic.com>
         <20200514161559.GA15603@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2020-05-14 at 09:15 -0700, Sean Christopherson wrote:
> On Thu, May 14, 2020 at 04:16:37AM -0500, Dr. Greg wrote:
> > What we would recommend at this point is that you and Jarkko do the
> > Linux community and beyond a favor and wire up a simple kernel
> > command-line parameter that controls the ability of the driver to be
> > used, ie. enables/disables access to /dev/sgx/enclave.
> 
> I'm not opposed to adding a kernel param to disable SGX.  At one point
> there was a proposal to extend clearcpuid to allow disabling multiple
> feature bits, but it looks like that went the way of the dodo.
> 
> Note, such a param would disable SGX entirely, e.g. clear the feature bit
> in /proc/cpuinfo and prevent any in-kernel SGX code from running.

Greg, you are free to submit a patch for review that adds any possible
kernel command line parameter SGX and beyond. SGX support does not "wire
up" anything that would prevent reviewing such patches.

/Jarkko

