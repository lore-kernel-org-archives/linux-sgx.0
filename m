Return-Path: <SRS0=I7Yp=4J=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1C82C35647
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Feb 2020 12:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 811DC24656
	for <linux-sgx@archiver.kernel.org>; Fri, 21 Feb 2020 12:53:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgBUMxW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 21 Feb 2020 07:53:22 -0500
Received: from mga17.intel.com ([192.55.52.151]:55135 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726909AbgBUMxW (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 21 Feb 2020 07:53:22 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Feb 2020 04:53:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,468,1574150400"; 
   d="scan'208";a="409128495"
Received: from mklimasz-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.87.58])
  by orsmga005.jf.intel.com with ESMTP; 21 Feb 2020 04:53:06 -0800
Date:   Fri, 21 Feb 2020 14:53:04 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jordan Hand <jorhand@linux.microsoft.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-security-module@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: [PATCH v26 10/22] x86/sgx: Linux Enclave Driver
Message-ID: <20200221125242.GA3112@linux.intel.com>
References: <20200209212609.7928-1-jarkko.sakkinen@linux.intel.com>
 <20200209212609.7928-11-jarkko.sakkinen@linux.intel.com>
 <15074c16-4832-456d-dd12-af8548e46d6d@linux.microsoft.com>
 <20200220181345.GD3972@linux.intel.com>
 <7738b3cf-fb32-5306-5740-59974444e327@linux.microsoft.com>
 <20200220184842.GE3972@linux.intel.com>
 <20200220221607.GB26618@linux.intel.com>
 <2c077197-a8a7-feac-58ea-e901c92fb58b@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c077197-a8a7-feac-58ea-e901c92fb58b@linux.microsoft.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Feb 20, 2020 at 04:11:04PM -0800, Jordan Hand wrote:
> On 2/20/20 2:16 PM, Jarkko Sakkinen wrote:
> > On Thu, Feb 20, 2020 at 10:48:42AM -0800, Sean Christopherson wrote:
> >> My biggest concern for allowing PROT_EXEC if RIE is that it would result
> >> in #PF(SGX) (#GP on Skylake) due to an EPCM violation if the enclave
> >> actually tried to execute from such a page.  This isn't a problem for the
> >> kernel as the fault will be reported cleanly through the vDSO (or get
> >> delivered as a SIGSEGV if the enclave isn't entered through the vDSO), but
> >> it's a bit weird for userspace as userspace will see the #PF(SGX) and
> >> likely assume the EPC was lost, e.g. silently restart the enclave instead
> >> of logging an error that the enclave is broken.
> > 
> > I think right way to fix the current implementation is to -EACCES mmap()
> > (and mprotect) when !!(current->personality & READ_IMPLIES_EXEC).
> > 
> 
> I agree. It still means userspace code with an executable stack can't
> mmap/mprotect enclave pages and request PROT_READ but the check you've
> proposed would more consistently enforce this which is easier to
> understand from userspace perspective.

Thank you. Your observation was really important because having half
working RIE support hanging around would only have potential to cause
unnecessary maintenance burden. It would even make adding a legit RIE
support later on somewhat more difficult.

I updated the commit under discussion in my tree [*] with a fix that
adds the following to the beginning of sgx_encl_may_map():

/*
 * Disallow RIE tasks as their VMA permissions might conflict with the
 * enclave page permissions.
 */
if (!!(current->personality & READ_IMPLIES_EXEC))
	return -EACCES;

[*] https://github.com/jsakkine-intel/linux-sgx.git

/Jarkko
