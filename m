Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 311EFC4338F
	for <linux-sgx@archiver.kernel.org>; Wed, 11 Aug 2021 02:06:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F352860EB5
	for <linux-sgx@archiver.kernel.org>; Wed, 11 Aug 2021 02:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231366AbhHKCHT (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 10 Aug 2021 22:07:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231233AbhHKCHT (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 10 Aug 2021 22:07:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C2DD60E97;
        Wed, 11 Aug 2021 02:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628647616;
        bh=cmvkn5vjXg4s8KKyFN4ZVblMUkEoA3/npFbwq9Lsyjg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mKtAXjhFRVZG+kFLfOVNa8w23AWIXhnZxIoAdM5524m1XLoxaHsaO5b4To/bshxAQ
         K/ucS/eyfgFvXytLDVa5SA71cI4IXH01Z/GYrwB2T0Qx2nvZJP9ce48KhVAjfhZmFh
         rVxndjL7LvC52PLhUxyfxxKdmo1mpCs5jnzMc4tRXfJUP0jLUFGlSQZeK6bh6Z0WRe
         V1u/99jSXKtfBGQVoPZOgJIaYf2Wat518a7Pd0qi1Mlr6W57aybpijqDDFKVl5lTf0
         gYHrukLXVvBzcvrXdduyPLrc9sxBtGmIuNLNOXe60s0pxh2rFZlmzSo7FPOn+6UfCM
         9L+n2/su+C92A==
Date:   Wed, 11 Aug 2021 05:06:53 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org
Cc:     Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH RFC] x86/sgx: Add a read-only sysctl attribute
 kernel.sgx.total_mem
Message-ID: <20210811020653.e5la5ifqwpxmd66g@kernel.org>
References: <20210811020438.849688-1-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210811020438.849688-1-jarkko@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 11, 2021 at 05:04:38AM +0300, Jarkko Sakkinen wrote:
> Acked-by: Dave Hansen <dave.hansen@linux.intel.com>

This went in by mistake.

/Jarkko
