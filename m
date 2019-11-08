Return-Path: <SRS0=KbJW=ZA=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C747C5DF60
	for <linux-sgx@archiver.kernel.org>; Fri,  8 Nov 2019 08:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A92C21D7E
	for <linux-sgx@archiver.kernel.org>; Fri,  8 Nov 2019 08:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbfKHIFO (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 8 Nov 2019 03:05:14 -0500
Received: from mga07.intel.com ([134.134.136.100]:7323 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727421AbfKHIFO (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 8 Nov 2019 03:05:14 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Nov 2019 00:05:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,280,1569308400"; 
   d="scan'208";a="377700784"
Received: from rafalwi-mobl.ger.corp.intel.com (HELO localhost) ([10.252.3.149])
  by orsmga005.jf.intel.com with ESMTP; 08 Nov 2019 00:05:02 -0800
Date:   Fri, 8 Nov 2019 10:05:01 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Stephen Smalley <sds@tycho.nsa.gov>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v23 12/24] x86/sgx: Linux Enclave Driver
Message-ID: <20191108080501.GA3370@linux.intel.com>
References: <20191028210324.12475-1-jarkko.sakkinen@linux.intel.com>
 <20191028210324.12475-13-jarkko.sakkinen@linux.intel.com>
 <173a196e-fa6b-23b8-c818-dfca6cdadcc6@tycho.nsa.gov>
 <20191031211721.GD10507@linux.intel.com>
 <f91d788c-b372-8e2f-7ffb-995f501b5d6b@tycho.nsa.gov>
 <4bf866ae-adc8-7902-3714-b62e548d8584@tycho.nsa.gov>
 <20191101153238.GA2657@linux.intel.com>
 <f3a3d137-a187-9090-f5af-da306ced5371@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f3a3d137-a187-9090-f5af-da306ced5371@tycho.nsa.gov>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 01, 2019 at 01:16:59PM -0400, Stephen Smalley wrote:
> On 11/1/19 11:32 AM, Sean Christopherson wrote:
> > On Fri, Nov 01, 2019 at 09:28:17AM -0400, Stephen Smalley wrote:
> > > On 11/1/19 9:16 AM, Stephen Smalley wrote:
> > > > So, IIUC, that means that merging the driver will create a regression with
> > > > respect to LSM control over executable mappings that will only be
> > > > rectified at some future point in time if/when someone submits LSM hooks
> > > > or calls to existing hooks to restore such control.  That doesn't seem
> > > > like a good idea.  Why can't you include at least that basic level of
> > > > control now?  It is one thing to defer finer grained control or
> > > > SGX-specific access controls to the future - that I can understand.  But
> > > > introducing a regression in the existing controls is not really ok.
> > > 
> > > Unless you are arguing that the existing checks on mmap/mprotect of
> > > /dev/sgx/enclave are a coarse-grained approximation (effectively requiring
> > > WX to the file or execmem for any user of SGX).
> > 
> > Yes, that's the argument as running any enclave will require RWX access to
> > /dev/sgx/enclave.  EXECMEM won't trigger for SGX users as /dev/sgx/enclave
> > must be MAP_SHARED and it's a non-private file (not backed by anonymous
> > inode, in case I got the file terminology wrong).
> 
> Ok, so for SELinux's purposes, one will need to allow :file { open ioctl map
> read write execute } to whatever type is ultimately assigned to
> /dev/sgx/enclave in order to use SGX.

AFAIK yes.

/Jarkko
