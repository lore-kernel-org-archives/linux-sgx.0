Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=BAYES_05,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D410CC07E9B
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Jul 2021 16:29:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B69E0601FE
	for <linux-sgx@archiver.kernel.org>; Fri,  9 Jul 2021 16:29:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbhGIQcH (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 9 Jul 2021 12:32:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:58266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229627AbhGIQcH (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 9 Jul 2021 12:32:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75EC6613CA;
        Fri,  9 Jul 2021 16:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625848164;
        bh=RwviPM07Qe2nCRpEFtpWX6FjU+ANwP8piVW/VuJM5qw=;
        h=Date:From:To:Subject:From;
        b=Z7S+fynyF1CdO1oBxfRuWf9s6g9QW99MCCe3AKsADWGbMq2lpDAzE96CUe4cfN+pW
         DYpF2m+5NWtq2vcRN8z5nlcntPQ/dTDFT4o3brmv4/1ghFWYTKP45s68zSOPMCc/I1
         /qIHGdAoO5Rj2+F4toaBGKTMlIJ7yo/BK1VGoekANsj2SEbunyGots4UaDGDLlpmBV
         AnhNpxzQea/YJciS3DW6nNqXMNfIEHhKVQoAppFSGKgx2a3tF/SyjxN1+4VhA88a0E
         WoQuCuuU51bQdH4vwIJEEO14bRKL5ea2ajvLOU5ii8b3U5MJkh/zzGW3By3rtYqUSQ
         cyimzcMYOFzBg==
Date:   Fri, 9 Jul 2021 19:29:21 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org, linux-integrity@vger.kernel.org
Subject: Vacation weeks 28, 29
Message-ID: <20210709162921.d3ehaeabdsr5kr6x@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

I'm on leave two upcoming weeks: 28 and 29. Expect slow response but
I'll check LKML at minimum once a week.

/Jarkko
