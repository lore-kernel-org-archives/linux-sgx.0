Return-Path: <SRS0=Qwf+=N3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29C96C43441
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Nov 2018 01:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDE5E2146D
	for <linux-sgx@archiver.kernel.org>; Fri, 16 Nov 2018 01:39:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EDE5E2146D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbeKPLuD (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 16 Nov 2018 06:50:03 -0500
Received: from mga04.intel.com ([192.55.52.120]:22415 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726518AbeKPLuD (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 16 Nov 2018 06:50:03 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Nov 2018 17:39:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,238,1539673200"; 
   d="scan'208";a="96705903"
Received: from sfhansen-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.254.82])
  by FMSMGA003.fm.intel.com with ESMTP; 15 Nov 2018 17:39:37 -0800
Date:   Fri, 16 Nov 2018 03:39:37 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org
Cc:     dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@linux.intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, mark.shanahan@intel.com, luto@amacapital.net
Subject: Re: [PATCH v7 00/17] Removed nested TPM operations
Message-ID: <20181116013937.GA28021@linux.intel.com>
References: <20181116013527.26903-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181116013527.26903-1-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 16, 2018 at 03:35:27AM +0200, Jarkko Sakkinen wrote:
> [was Detach TPM space code out of the tpm_transmit() flow but the scope
>  expanded a bit.]
> 
> Make the changes necessary to detach TPM space code and TPM activation
> code out of the tpm_transmit() flow because of both of these can cause
> nested tpm_transmit() calls. The nesteds calls make the whole flow hard
> to maintain, and thus, it is better to just fix things now before this
> turns into a bigger mess.
> 
> v7:
> *  Reorganize series so that more trivial and self-contained changes are
>    in the head.
> 
> v6:
> * When tpm_validate_commmand() was moved to tpm2-space.c, the struct for
>   the TPM header was incorrectly declared as struct tpm_input_header.
> * Fix return value in tpm_validate_command().
> 
> v5:
> * Add the missing rev's from Stefan Berger.
> 
> v4:
> * Return 0 from pcrs_show() when tpm1_pcr_read() fails.
> * Fix error handling flow in tpm_try_transmit().
> * Replace struct tpm_input_header and struct tpm_output_header with
>   struct tpm_header.
> 
> v3:
> * Encapsulate power gating code to tpm_chip_start() and tpm_chip_stop().
> * Move TPM power gating code and locking to tpm_try_get_ops() and
>   tpm_put_ops().
> * Call power gating code directly in tpm_chip_register() and
>   tpm2_del_space().
> 
> v2:
> * Print tpm2_commit_space() error inside tpm2_commit_space()
> * Error code was not printed when recv() callback failed. It is
>   fixed in this version.
> * Added a patch that removes @space from tpm_transmit().
> * Fixed a regression in earlier series. Forgot to amend the change
>   from the staging area that renames NESTED to UNLOCKED in tpm2-space.c.
> 
> Jarkko Sakkinen (17):
>   tpm: use tpm_buf in tpm_transmit_cmd() as the IO parameter
>   tpm: fix invalid return value in pubek_show()
>   tpm: return 0 from pcrs_show() when tpm1_pcr_read() fails
>   tpm: print tpm2_commit_space() error inside tpm2_commit_space()
>   tpm: declare struct tpm_header
>   tpm: access command header through struct in tpm_try_transmit()
>   tpm: encapsulate tpm_dev_transmit()
>   tpm: call tpm2_flush_space() on error in tpm_try_transmit()
>   tpm: clean up tpm_try_transmit() error handling flow
>   tpm: move tpm_validate_commmand() to tpm2-space.c
>   tpm: move TPM space code out of tpm_transmit()
>   tpm: remove @space from tpm_transmit()
>   tpm: use tpm_try_get_ops() in tpm-sysfs.c.
>   tpm: remove TPM_TRANSMIT_UNLOCKED flag
>   tpm: introduce tpm_chip_start() and tpm_chip_stop()
>   tpm: take TPM chip power gating out of tpm_transmit()
>   tpm: remove @flags from tpm_transmit()
> 
>  drivers/char/tpm/tpm-chip.c       | 105 +++++++++++-
>  drivers/char/tpm/tpm-dev-common.c |  45 ++++-
>  drivers/char/tpm/tpm-interface.c  | 267 ++++++------------------------
>  drivers/char/tpm/tpm-sysfs.c      | 138 +++++++++------
>  drivers/char/tpm/tpm.h            |  64 +++----
>  drivers/char/tpm/tpm1-cmd.c       |  28 +---
>  drivers/char/tpm/tpm2-cmd.c       |  72 +++-----
>  drivers/char/tpm/tpm2-space.c     |  93 ++++++++---
>  drivers/char/tpm/tpm_i2c_atmel.c  |   5 +-
>  drivers/char/tpm/tpm_vtpm_proxy.c |  12 +-
>  drivers/char/tpm/xen-tpmfront.c   |   2 +-
>  11 files changed, 406 insertions(+), 425 deletions(-)
> 
> -- 
> 2.19.1
> 

Oops, sorry. Please ignore.

/Jarkko
