Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D58AAC1B0D8
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Dec 2020 13:07:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A90A523F5A
	for <linux-sgx@archiver.kernel.org>; Fri, 11 Dec 2020 13:07:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436672AbgLKNGp (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 11 Dec 2020 08:06:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:48722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436642AbgLKNGj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 11 Dec 2020 08:06:39 -0500
Date:   Fri, 11 Dec 2020 15:05:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607691958;
        bh=AORx6xXPhaEtdLEpuJjiTlCweDA2O/sjhVyOfEe4mfk=;
        h=From:To:Subject:From;
        b=EfGe9b0JOEdRdsSDbcZ9NrHe73kP/3W1qwblvCJB52CwO93S3WEO+G9XwYdrPkDgR
         Aj+tLi19/nPAgIBgxhyVemA3mfQqDRyVUkBJa/iHmfwq+w6BvW5Sb2W/vAdFyUoG+y
         qiIHn8AUtK2XHIEx0lRbCdklPmPfuMh04G5nfyaUGW9XXyOBE+bFyer+QR14njmWUd
         K26B6D82fuQy3CtjOLkP7v/YC5qfevqe8g/IVI7REHBNtJpknOH+5JIWmVAHaJ/a1t
         FnZwDVbjq/tjVlgLUEZxvBoOKY0YJ6CxkpeBHnO9J6m8lE/MVakajGb0DYuG2VJOTE
         w0tmD2t87O+WQ==
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     linux-sgx@vger.kernel.org, linux-integrity@vger.kernel.org,
        keyrings@vger.kernel.org
Subject: Away next week (51)
Message-ID: <20201211130554.GA30536@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

I'm away next week (vacation). Except some latency.

/Jarkko
