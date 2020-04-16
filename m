Return-Path: <SRS0=joXX=6A=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AAFAC352BE
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Apr 2020 17:43:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 552802064A
	for <linux-sgx@archiver.kernel.org>; Thu, 16 Apr 2020 17:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732560AbgDPRnr (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 Apr 2020 13:43:47 -0400
Received: from mga06.intel.com ([134.134.136.31]:18107 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732880AbgDPRnn (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 16 Apr 2020 13:43:43 -0400
IronPort-SDR: 44RlFTQGh/LZ2DedaRNjc7fyEa8p2Qbtq58xOIt6icHQsh+3iKdNlkpuTMI0sPx4gM+c3qf9kB
 wt+AXOGdcGvw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 10:43:42 -0700
IronPort-SDR: LB34mCGso+meio8wieixShp3B5Fz+yiBWfJABaZxCWzzX0E4/oGGzOh8lYP8A0MplUUVO8wc8T
 vEzuVys9T7nQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,391,1580803200"; 
   d="scan'208";a="288973714"
Received: from otazetdi-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.42.128])
  by fmsmga002.fm.intel.com with ESMTP; 16 Apr 2020 10:43:40 -0700
Date:   Thu, 16 Apr 2020 20:43:40 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     linux-sgx@vger.kernel.org, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com
Subject: Re: [PATCH 1/1] Implement cryptographic initialization control.
Message-ID: <20200416174340.GH199110@linux.intel.com>
References: <20200407092039.GA11846@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407092039.GA11846@wind.enjellic.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, Apr 07, 2020 at 04:20:39AM -0500, Dr. Greg wrote:
> This patch introduces the ability of the platform owner to
> implement cryptographically controlled enclave initialization
> policy.  This functionality provides the platform owner with the
> ability to use the identity modulus signature of an enclave
> signer (SHA256 hash of the modulus of the signing key) to gate
> access to enclave initialization, rather then simply relying
> on discretionary access controls that are applied to the SGX
> relevant device driver nodes.
> 
> The following policy functionality is introduced in this commit:
> 
> 1.) Control over which keys are allowed to initialize an
> enclave.
> 
> 2.) Control over which keys are allowed to implement launch
> enclaves.
> 
> 3.) Control over which keys are allowed to initialize enclaves
> that have access to the PROVISION_KEY attribute.
> 
> For each policy type a plurality of key signatures are allowed.
> 
> Absent an intent by the platform owner/administrator to use
> cryptographic initialization policies, this functionality does
> not change the standard behavior of the driver, which is to
> allow any enclave presented to the driver to be initialized.
> 
> Cryptographic initialization policy is accessed through the
> following three pseudo-files that are implemented by this patch:
> 
> /sys/kernel/security/signing_keys
> 
> /sys/kernel/security/launch_keys
> 
> /sys/kernel/security/provisioning_keys
> 
> Policy keys are registered with the driver by writing the identity
> modulus signature to these files in simple hexadecimal format, ie:
> 
> 0000000000000000000000000000000000000000000000000000000000000000
> 
> The current list of policy keys can be displayed by reading the
> contents of the pseudo-files.
> 
> In addition to a key signature, the following keywords are
> accepted as valid entries for a policy file:
> 
> clear
> 
> lock
> 
> The 'clear' keyword causes all existing entries in a policy list
> to be deleted.
> 
> The 'lock' keyword causes any further modifications or access to
> a policy list to be denied.
> 
> All of the policy code is implemented in a single file, policy.c,
> with minimal impact to the driver at large.  Since the calculation
> of the identity modulus signature needed to program a launch control
> register is effectively a policy decision, the code to compute the
> signature was moved from the ioctl.c file to the policy.c file.
> 
> In order to support a plurality of launch keys the code that
> loops over initialization attempts was pushed downward into a new
> function that is named as follows:
> 
> sgx_try_init()
> 
> Primarily to avoid excessive indentation that would otherwise be
> needed in the sgx_encl_init() function.
> 
> Signed-off-by: Dr. Greg Wettstein <greg@enjellic.com>

Sorry, would have responded earlier but forgot to check the
folder where fdm pulls mailing list email's. For shorter
latency I recommend CC'ing.

This comes down to the fact that we are not doing anything
that would prevent doing something similar post upstreaming
(e.g. add a new ioctl for token version of EINIT or whatever)
but is not something that we want to include right now. It is
an additional feature (like other features e.g. virtualization)

/Jarkko
