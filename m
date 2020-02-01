Return-Path: <SRS0=7EJM=3V=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2942CC33CB3
	for <linux-sgx@archiver.kernel.org>; Sat,  1 Feb 2020 19:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08CCB20661
	for <linux-sgx@archiver.kernel.org>; Sat,  1 Feb 2020 19:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726354AbgBATgC (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 1 Feb 2020 14:36:02 -0500
Received: from mga04.intel.com ([192.55.52.120]:11102 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726335AbgBATgC (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 1 Feb 2020 14:36:02 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Feb 2020 11:36:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,391,1574150400"; 
   d="scan'208";a="310324210"
Received: from mtaylo3-mobl1.ger.corp.intel.com (HELO localhost) ([10.251.87.188])
  by orsmga001.jf.intel.com with ESMTP; 01 Feb 2020 11:35:59 -0800
Date:   Sat, 1 Feb 2020 21:35:59 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org, bp@alien8.de
Subject: Re: [PATCH for_v25 0/3] x86/sgx: Fix feature control rebase
Message-ID: <20200201193559.GA7791@linux.intel.com>
References: <20200201174940.20984-1-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200201174940.20984-1-sean.j.christopherson@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Feb 01, 2020 at 09:49:37AM -0800, Sean Christopherson wrote:
> Two patches to fix the Feature Control MSR bit definitions, which didn't
> get correctly rebased.
> 
> Patch 03 reworks SGX handling of Feature Control to use the new feat_ctl.c
> code, which was the entire point of that series.  Patch 03 is a drop-in
> replacement for 4249f9b240b7 ("x86/cpu/intel: Detect SGX supprt").
> 
> *** DISCLAIMER ***
> These patches are untested against your master, as your master doesn't boot
> on my system.  The fully tested version is available at 
> https://github.com/sean-jc/linux.git, branch sgx/for_jarkko_v25_rebased.
> I'll dig into the boot issue next week.

Possibly it was related  that I was temporarily on top of x86/tip?  It
is now again on top of Linus' tree. I created v25-rc2 tag that has
these updates:

tag v25-rc2
Tagger: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Date:   Sat Feb 1 21:27:24 2020 +0200

x86/sgx: v25-rc2

* Fix a double-free issue when SGX_IOC_ENCLAVE_ADD_PAGES
  fails on executing ENCLS[EADD]. The rollback path executed
  radix_tree_delete() on the same address twice when this happened.
* Return -EINTR instead of -ERESTARTSYS in SGX_IOC_ENCLAVE_ADD_PAGES when
  a signal is pending.
* As requested by Borislav, move the CPUID 0x12 features to their own word
  in cpufeatures.
* Sean fixed a bug from sgx_reclaimer_write() where sgx_encl_put_backing()
  was called with an uninitialized pointer when sgx_encl_get_backing()
  fails.
* Migrated /dev/sgx/* to misc. This is future-proof as struct miscdevice
  has 'groups' for setting up sysfs attributes for the device.
* Use device_initcall instead of subsys_initcall so that misc_class is
  initialized before SGX is initialized.
* Return -EACCES in SGX_IOC_ENCLAVE_INIT when caller tries to select
  enclave attributes that we the kernel does not allow it to set instead
  of -EINVAL.
* Unless SGX public key MSRs are writable always deny the feature from
  Linux. Previously this was only denied from driver. How VMs should be
  supported is not really part of initial patch set, which makes this
  an obvious choice.
* Rewrote the documentation. Lessened the fine-grained micro architecture
  details as they can be looked up from Intel SDM in order to make the
  core ideas more approachable.
-----BEGIN PGP SIGNATURE-----

iJYEABYIAD4WIQRE6pSOnaBC00OEHEIaerohdGur0gUCXjXRMiAcamFya2tvLnNh
a2tpbmVuQGxpbnV4LmludGVsLmNvbQAKCRAaerohdGur0ihBAQC3VE2u6zyPYFLN
hCBFEF3LKqpNk26DjkO9M5tRZfUhSgEA/sF6AKHJRDqYUePW6N6Rtc3GOZY9DmbD
R+qOg0XcbAs=
=OtqV
-----END PGP SIGNATURE-----

If you fix any regression, use solely this tag as the baseline for
fixes. I worry about possible merge conflicts with the master.

/Jarkko
