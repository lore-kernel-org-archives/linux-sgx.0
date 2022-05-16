Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4485C433EF
	for <linux-sgx@archiver.kernel.org>; Mon, 16 May 2022 18:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345009AbiEPSrg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 16 May 2022 14:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbiEPSrf (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Mon, 16 May 2022 14:47:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745553E5FD
        for <linux-sgx@vger.kernel.org>; Mon, 16 May 2022 11:47:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D1C0B815A6
        for <linux-sgx@vger.kernel.org>; Mon, 16 May 2022 18:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82A7DC385AA;
        Mon, 16 May 2022 18:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652726851;
        bh=wNKattsifC2Wb5+MansY673YOjdrKrAIO3asBRzrsUw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Alpt7uqj/OUmLxDiqAcP01OFVdTjjnYumFdPqe9hCR++zFZpr247fJ43lSOljPcTQ
         q7CRM95mbtBBRn6dDvJOecuV8h/0b9kAxtY00kkn9gwRhWGwm8Xp5fH0wHQOZR3d/o
         +EoE+198ro5QWml6iHAV80B9FwiZmsQC612rPPJ36qaZgv+MLTu1zJhjv2aFXanJFt
         T7VMZ8xOOjyQMjXbS6G/1PwDwIrcyKl2cRoXi5R6ZXkuJ7OkUMTNkPUYhLE2uVVkV0
         x4O4LLyNMvl8k8P1z0NHDqoH1+TEhFWC8XzkQa0rIoeVRGWH/zqY3vha1Sx6jarZ7o
         jvARl5A577aUQ==
Date:   Mon, 16 May 2022 21:45:56 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        reinette.chatre@intel.com
Subject: Re: VMA's not getting merged
Message-ID: <YoKb5P+VixJUn6xT@kernel.org>
References: <884c7ea454cf2eb0ba2e95f7c25bd42018824f97.camel@kernel.org>
 <c148ab48-1b70-6e20-5742-b0b2dc014dc3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c148ab48-1b70-6e20-5742-b0b2dc014dc3@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, May 16, 2022 at 07:13:42AM -0700, Dave Hansen wrote:
> On 5/14/22 18:20, Jarkko Sakkinen wrote:
> > Looks like VMA's do not get merged properly:
> ...
> > 7f8f0800b000-7f8f08014000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > 7f8f08014000-7f8f08025000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > 7f8f08025000-7f8f08046000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > 7f8f08046000-7f8f0804a000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > 7f8f0804a000-7f8f0804b000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > 7f8f0804b000-7f8f0804c000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > 7f8f0804c000-7f8f0804d000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> > 7f8f0804d000-7f8f0804e000 rw-s 00000000 00:05 84                         /dev/sgx_enclave
> 
> I remember some issue with VM_IO VMAs not getting merged, but I don't
> remember how we fixed or addressed it.
> 
> Seems like something we can and should fix, though.

Access pattern here is series of small adjacent mmaps (brk()).

During upstreaming vma_close callback was eliminated to allow VMA's getting
merged. I'll try to trace the condition in the call path triggering this.

BR, Jarkko
